# Nix カスタムパッケージ管理ガイド

gleam-overlay のパターンを参考にした、複数バージョン共存・自動更新の仕組みを解説します。

## 全体像

```
新リリース検知 (GitHub Actions / 手動)
    ↓
update-package.py
    ↓ GitHub API でタグ取得
    ↓ nurl で srcHash 計算
    ↓ raw.githubusercontent.com から Cargo.lock ダウンロード
    ↓
versions.json を更新 + locks/*.lock を追加
    ↓
create-pull-request アクションが PR を作成
    ↓
マージで overlay が新バージョンを自動公開
```

## ファイル構成（パッケージごとに同じ構造）

```
nix/
  pkgs/
    <name>/
      default.nix       # version / srcHash / cargoLockFile を引数で受け取る
      versions.json     # バージョン管理の中心ファイル
      locks/
        0.1.0.lock      # バージョンごとの Cargo.lock
        0.2.0.lock
  overlays/
    <name>-overlay.nix  # versions.json を読んで mapAttrs' で動的生成

.github/
  scripts/
    update-package.py   # 共通更新スクリプト（全パッケージで再利用）
  workflows/
    update-nix-packages.yml  # 週次自動更新ワークフロー
```

## 新しい Rust パッケージを追加する手順

### 1. `nix/pkgs/<name>/default.nix` を作成

引数は必ず `version` / `srcHash` / `cargoLockFile` の3つを受け取る形にする。

```nix
{
  lib,
  rustPlatform,
  fetchFromGitHub,
  version,
  srcHash,
  cargoLockFile,
}:

rustPlatform.buildRustPackage {
  pname = "<name>";
  inherit version;

  src = fetchFromGitHub {
    owner = "<owner>";
    repo = "<repo>";
    tag = "v${version}";   # タグフォーマットに合わせて変更
    hash = srcHash;
  };

  cargoBuildFlags = [ "--bin" "<binary-name>" ];

  cargoLock = {
    lockFile = cargoLockFile;
    allowBuiltinFetchGit = true;  # git 依存クレートがある場合に必要
  };

  doCheck = false;

  meta = with lib; {
    description = "...";
    mainProgram = "<binary-name>";
    homepage = "https://github.com/<owner>/<repo>";
    license = licenses.mit;
  };
}
```

> **なぜ `cargoLock` を使うのか？**
>
> `cargoHash`（単一ハッシュ）は git 依存クレート（例: GitHub の fork をブランチ指定で使う）があると
> `fetch-cargo-vendor-util` がクラッシュする。
> `cargoLock + allowBuiltinFetchGit = true` なら Nix 組み込みフェッチャーで個別取得できる。
> 統一性のために git 依存がないパッケージも `cargoLock` 方式を採用している。

### 2. `nix/pkgs/<name>/locks/` ディレクトリを作成し、初回の Cargo.lock を置く

```bash
mkdir -p nix/pkgs/<name>/locks

# GitHub からダウンロード（タグとファイルパスはパッケージに合わせて変更）
curl -sL https://raw.githubusercontent.com/<owner>/<repo>/v<version>/Cargo.lock \
  -o nix/pkgs/<name>/locks/<version>.lock
```

### 3. `nix/pkgs/<name>/versions.json` を作成

```bash
# srcHash は nurl で取得
nix run nixpkgs#nurl -- https://github.com/<owner>/<repo> v<version>
```

取得したハッシュを使って作成：

```json
{
  "latest": "<version>",
  "versions": {
    "<version>": {
      "srcHash": "sha256-..."
    }
  }
}
```

> `update-package.py` は `versions.json` が存在しない場合も自動で初期化するため、
> 初回は `versions.json` を省略して CI に任せることもできる。

### 4. `nix/overlays/<name>-overlay.nix` を作成

```nix
final: prev:
let
  lib = prev.lib;
  versionData = builtins.fromJSON (builtins.readFile ../pkgs/<name>/versions.json);
  locksDir = ../pkgs/<name>/locks;

  mk<Name> =
    { version, srcHash }:
    prev.callPackage ../pkgs/<name> {
      inherit version srcHash;
      cargoLockFile = "${locksDir}/${version}.lock";
    };

  # "0.104.0" -> "104", "0.4.2" -> "004"
  toAttrSuffix =
    version:
    let
      minor = builtins.elemAt (lib.splitString "." version) 1;
    in
    lib.fixedWidthString 3 "0" minor;

in
lib.mapAttrs' (version: meta: {
  name =
    if version == versionData.latest
    then "<name>"
    else "<name>_${toAttrSuffix version}";
  value = mk<Name> { inherit version; inherit (meta) srcHash; };
}) versionData.versions
```

> `mapAttrs'`（アポストロフィ付き）は `{ name, value }` を返してキーを自由に変換できる版。
> これにより `pkgs.<name>`（最新）と `pkgs.<name>_104`（旧バージョン）が自動生成される。

### 5. `flake.nix` の overlays に追加

既存の overlay リストに追加する（形式は既存のものに合わせる）。

### 6. `update-nix-packages.yml` の matrix に追加

```yaml
matrix:
  pkg:
    # 既存エントリの下に追記
    - name: <name>
      owner: <owner>
      repo: <repo>
      tag_prefix: v           # タグが "v0.4.2" なら "v"、"rust-v0.104.0" なら "rust-v"
      cargo_lock_subpath: Cargo.lock  # サブディレクトリにある場合は "subdir/Cargo.lock"
```

### 7. 新規ファイルを git add してビルド確認

```bash
git add nix/pkgs/<name>/ nix/overlays/<name>-overlay.nix

# 評価確認（高速）
nix eval .#packages.aarch64-darwin --apply builtins.attrNames

# ビルド確認
nix build .#packages.aarch64-darwin.<name> --no-link

# バイナリ起動確認
nix run .#packages.aarch64-darwin.<name> -- --version
```

> **重要:** Nix flake は Git で追跡されているファイルしか `builtins.readFile` できない。
> コミット前でも `git add` さえすれば読み込めるようになる。

---

## 自動更新の仕組み（CI）

### 週次スケジュール
毎週月曜 00:00 UTC に `update-nix-packages.yml` が起動し、
全パッケージを並列チェックする（`fail-fast: false` で1つが失敗しても他は継続）。

### 更新フロー
1. `update-package.py` が GitHub API で最新タグを取得
2. `versions.json` に既に存在するバージョンなら "Already at X, nothing to do." でスキップ
3. 新バージョンなら `nurl` で srcHash 計算 → Cargo.lock ダウンロード → JSON 更新
4. `git diff` で変更があれば `create-pull-request` アクションが PR を作成
5. PR タイトル: `chore(nix/<name>): update to <version>`

### 手動実行
GitHub Actions の「Run workflow」ボタンから `workflow_dispatch` で即時実行できる。
初回セットアップ時の動作確認に使う。

---

## バージョン属性名のルール

| `versions.json` の latest | 生成される属性名 |
|--------------------------|----------------|
| そのバージョンが latest   | `pkgs.<name>` |
| latest より古い           | `pkgs.<name>_<minor3桁>` |

例: codex の場合
- `0.104.0` が latest → `pkgs.codex`
- `0.31.0` が旧版 → `pkgs.codex_031`
- `0.4.0` が旧版 → `pkgs.codex_004`

---

## トラブルシューティング

| エラー | 原因 | 対処 |
|--------|------|------|
| `Path '...' is not tracked by Git` | `git add` 前に `nix build` を実行した | `git add` してから再実行 |
| `hash not found in nurl output` | nurl の出力フォーマットが変わった | `nurl` の出力を確認してスクリプトを修正 |
| `fetch-cargo-vendor-util` クラッシュ | git 依存クレートがあるのに `cargoHash` を使っている | `cargoLock + allowBuiltinFetchGit = true` に変更 |
| Cargo.lock が見つからない | タグやサブパスが間違っている | `--cargo-lock-subpath` の値を確認 |

## 既存パッケージ

| パッケージ | GitHub | タグ形式 | Cargo.lock パス |
|-----------|--------|---------|----------------|
| codex | openai/codex | `rust-v*` | `codex-rs/Cargo.lock` |
| octorus | ushironoko/octorus | `v*` | `Cargo.lock` |
