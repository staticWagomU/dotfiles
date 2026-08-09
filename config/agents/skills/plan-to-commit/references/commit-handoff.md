# plan → コミットメッセージ変換ルール

フェーズ5で、`plans/<slug>.md` の内容をコミットメッセージに変換する際の規則。

## まず既存コミット履歴を読む

このスキルはグローバル（プロジェクト非依存）なので、subject の言語・scope の付け方・本文の長さを本ファイルで決め打ちしない。コミットを組み立てる前に、対象リポジトリで以下を実行し、慣習を確認してから合わせる。

```
git log -20 --format='%s%n%b'
```

- subject が日本語か英語か
- `type(scope)` の scope をどの粒度で付けているか（ディレクトリ名、機能名、アプリ名など）
- 本文の分量（1文だけの簡潔なプロジェクトもあれば、変更点を箇条書きで詳細に書くプロジェクトもある）

以降のルールはこの慣習と矛盾しない範囲で適用する。

## subject

```
<type>(<scope>): <plan のタイトルを50字程度に圧縮した命令形>
```

- `type` は Conventional Commits に従う: `feat` / `fix` / `refactor` / `docs` / `test` / `chore` / `style` / `perf`。
- `scope` は変更対象のディレクトリ・モジュール名などから判断する（不明なら省略可）。
- plan の一行タイトルをそのまま使わず、命令形・50字程度に圧縮する。

## 本文の組み立て

```
<Structural change: | Behavioral change: | Visual change: | Behavioral coverage:> <1文で変更の要点>（プロジェクトの慣習に無ければ省略可。詳細は次節）

<plan の「背景 / なぜ」を 1〜3文に圧縮>

<plan の「方針」— 採った設計と捨てた案>

変更点:
- <変更計画の各項目を、実際にやったことに直して1行ずつ>

検証:
- <実際に実行して通ったコマンド・確認内容>
```

### 変更種別の宣言（Tidy First）

Kent Beck の Tidy First に基づき、本文の**冒頭1行で「構造変更か振る舞い変更か」を宣言する**。プレフィックスは以下の4種を使う。

- `Structural change:` — 挙動を変えないリファクタリング・整理
- `Behavioral change:` — 挙動を変える修正・機能追加
- `Visual change:` — 見た目・スタイルのみの変更
- `Behavioral coverage:` — 既存挙動に対するテスト追加など

実在するコミットの例:

```
style(karte-ui): distinguish actions from status chips

Visual change: reserve tonal styling for chips and use outlined or flat buttons by role.
```

```
refactor(storybook): standardize existing stories

Structural change: migrate audited stories to typed CSF3 and shared fixtures.
```

```
fix(karte-ui): correct empty sections and table spacing

Behavioral change: treat empty Kintone arrays as empty when opening edit sections.
```

対象リポジトリの既存コミットにこの宣言スタイルが見られない場合は無理に合わせず、上の「まず既存コミット履歴を読む」の慣習を優先する。

## 書いてはいけないこと

- plan の「やらないこと」節をそのまま貼らない（コミットメッセージは「やったこと」の記録であり、スコープ外の話は不要）。
- **未実行の検証項目を書かない**。実際に実行して通ったものだけを「検証:」に書く。
- `plans/xxx.md` へのパス参照を残さない。plan ファイルはコミット後に削除されるため、リンク切れになる。

## 実例

### Before（plan 全文の抜粋）

```markdown
# CLIの --context-only フラグが値を無視するバグを直す

## 背景 / なぜ
`--context-only=false` を指定しても常に true 扱いになり、コンテキスト収集をスキップできない。
CI のドライラン設定で無効化したいユーザーがいるが、現状回避策が無い。

## 方針
`parseArgs` が boolean フラグを常に `true` に固定していたのが原因。
`--flag=value` 形式のときだけ値をパースするよう分岐を追加する。
フラグパーサー自体を汎用ライブラリに置き換える案もあったが、影響範囲が広く今回のバグ修正の範囲を超えるため見送り。

## 変更計画
1. `src/cli/parseArgs.ts` — boolean フラグに `=value` が付与されている場合は明示値を優先するよう分岐を追加
2. `src/cli/parseArgs.test.ts` — `--context-only=false` のケースを追加

## 検証
- [ ] `bun run test:run`
- [ ] `bun run cli --context-only=false` を手元で実行し、コンテキスト収集がスキップされることを確認
```

### After（コミットメッセージ全文）

```
fix(cli): --context-only=false が無視される不具合を修正

--context-only=false を指定しても常に true 扱いになり、コンテキスト収集をスキップできなかった。
CI のドライラン設定で無効化したいユーザーがいたが、回避策が無かった。

parseArgs が boolean フラグを常に true に固定していたのが原因。--flag=value 形式のときだけ
値をパースするよう分岐を追加した。フラグパーサー自体を汎用ライブラリに置き換える案もあったが、
影響範囲が広く今回のバグ修正の範囲を超えるため見送った。

変更点:
- src/cli/parseArgs.ts に boolean フラグの明示値（=value）を優先する分岐を追加
- src/cli/parseArgs.test.ts に --context-only=false のケースを追加

検証:
- bun run test:run が通ることを確認
- bun run cli --context-only=false を実行し、コンテキスト収集がスキップされることを確認
```

対象リポジトリが変更種別の宣言スタイルを採っている場合、本文冒頭は以下のようになる（この例は挙動を変える修正なので `Behavioral change:`）。

```
fix(cli): --context-only=false が無視される不具合を修正

Behavioral change: --context-only=false 指定時にコンテキスト収集をスキップするよう修正。

--context-only=false を指定しても常に true 扱いになり、コンテキスト収集をスキップできなかった。
CI のドライラン設定で無効化したいユーザーがいたが、回避策が無かった。
...（以下 After 例と同じ）
```

## 分割コミットの判断基準

1コミット = 1つの取り消せる単位、を基準に分割するかどうかを判断する。

- plan の「変更計画」が独立した複数の意図（例: バグ修正 + 無関係なリファクタ）を含んでいる場合は分割する。
- 一方が revert されても他方の意味が壊れない場合は分割候補。
- テストとその対象実装は同じコミットにまとめる（テスト無しの実装コミットや、実装無しのテストコミットを作らない）。
- **構造変更（Structural change）と振る舞い変更（Behavioral change）を1コミットに混ぜない**（Tidy First の原則）。リファクタリングと機能修正が両方必要な plan では、先に構造変更のコミット、続けて振る舞い変更のコミットに分ける。
- 分割する場合、それぞれの subject/本文を上記ルールで個別に組み立てる。plan 側の「変更計画」の番号をコミット単位の目安として使ってよい。

## コミット実行時の実務メモ

- 長い本文は `-m` の連結ではなく、`/tmp/commit-msg-<slug>.txt` に書いて `git commit -F /tmp/commit-msg-<slug>.txt` で渡す（端末の折り返しで壊れるのを避けるため）。
- `--no-verify` は使わない。フックが落ちたら原因を直す。
- コミット結果は `| tail` などのパイプを付けずに実行し、終了コードと出力末尾を確認する（パイプすると失敗が exit 0 に見える）。
