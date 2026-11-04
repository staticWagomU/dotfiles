# dotfiles

輪ごむのお部屋 - Nix flake based dotfiles

## 事前準備

Nixを入れる
```shell
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```
参照: https://zero-to-nix.com/

## macOS (nix-darwin + home-manager)

nix-darwinを使用してシステム全体を宣言的に管理します。

### 初回セットアップ

```shell
sudo nix run nix-darwin -- switch --flake .#MacBookAir
```

### 2回目以降

```shell
sudo darwin-rebuild switch --flake .#MacBookAir
```

### 含まれる設定

- **Tailscale**: サービス自動起動 + GUI (Homebrew cask経由)
- **macOSシステム設定**: Dock, Finder, キーリピートなど
- **Touch ID for sudo**: 有効化
- **Homebrew統合**: caskの宣言的管理

## Linux (home-manager standalone)

```shell
# 初回
nix run home-manager/master -- switch --flake .#WSL

# 2回目以降
home-manager switch --flake .#WSL
```

## 利用可能な設定

| 名前 | システム | 説明 |
|------|----------|------|
| `MacBookAir` | aarch64-darwin | nix-darwin + home-manager |
| `MacBookPro` | aarch64-darwin | nix-darwin + home-manager |
| `WSL` | x86_64-linux | home-manager standalone |
| `ThinkpadT14Gen3` | x86_64-linux | home-manager standalone |
| `NucBox3` | x86_64-linux | home-manager standalone |

## flake更新

```shell
nix flake update
```

## 設定ファイルの管理

`~/.config/*` と `~/.*` の設定は、ファイルごとに方式を選びます。
`source = ../config/...` はNix storeに内容を保存し、
`mkOutOfStoreSymlink` は `~/dotfiles` のファイルを直接参照します。

| 方式 | 対象 |
|------|------|
| store | tmux、Ghostty、Zellij、Helix、lazygit、ユーザー用nix.conf、Yaziの設定・配色 |
| link | Fishの対話設定・自作functions/completions、WezTerm設定・ローカルプラグイン |
| linkを維持 | Nushell、PowerShell、Alacrittyの共通設定・配色、Vim/Neovim、Claude/Codexの既存リンク対象 |
| linkを維持（差分未取り込み） | Herdrのconfig.toml |

固定する設定とFishのファイル一覧は `home-manager/config-files.nix` にまとめています。
storeの設定はリポジトリを編集してrebuildすると反映され、対応する世代に戻すと内容も戻ります。
linkの設定は `~/dotfiles`（Vim/Neovimは `~/dotvim`）の編集を直接反映し、内容の復元はGitで行います。
どちらもアプリによって再読み込みや再起動が必要です。

Fishの `config.fish` 本体はHome Managerが生成し、その中からリポジトリの設定をsourceします。
自作functions/completionsはファイルごとにリンクし、プラグインが生成するファイルと共存させます。
新しいファイルの追加・削除時はrebuildが必要です。
Yaziも設定と同梱の配色だけを配置し、プラグイン・可変データ用のディレクトリは管理しません。

認証情報・履歴・セッション・キャッシュは追加で管理しません。
Claudeのsettings.jsonは既存の書き込み可能なリンクを維持し、
混在する自動更新項目をstoreに固定しません。
Codexのconfig.toml、Gemini設定の新規取り込みも行いません。
agent-skillsやOpenCodeなど、既存のNixモジュールが生成する設定はその方式を維持します。
Git設定の初期化とKarabinerの同期も従来どおりです。
ホームの棚卸しで見つかった未登録アプリは、この変更では自動追加しません。

初回適用前には既存ファイルとの衝突と内容差分を確認してください。
macOSは設定済みの `.backup` 退避を使用し、Linuxは必要に応じて
`home-manager switch -b backup --flake .#WSL` で退避できます。
同名のバックアップがすでにある場合は、適用前に別名で保管してください。

実機へ適用せずにmacOS設定をビルドするには、次を実行します。

```shell
nix build .#darwinConfigurations.MacBookAir.system --no-link
```
