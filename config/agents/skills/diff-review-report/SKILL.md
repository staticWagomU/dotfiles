---
name: diff-review-report
description: git差分を2段階レビュー（plan非開示レビュー → plan照合レビュー）し、意図ごとにグループ化した単一HTMLのレビュー画面を生成する。人間が画面上で採用/却下/コメントを付け、フィードバックmarkdownをコピーして元セッションへ戻せる。「差分をレビューして」「レビュー画面を作って」「実装をレビューして」やコードレビューのHTMLレポートを求められたときに使う。
---

# diff-review-report

git の差分を2段階でレビューし、単一HTMLのレビュー画面として出力するスキル。

## 使うタイミング / 前提

- 差分の指定方法: 既定は **未コミット差分**（作業ツリー。ステージ済み・未ステージ済みの両方を含む。`git diff HEAD` 相当）。ブランチ間で比較したい場合は `--base <ref>` に加えて `--head <ref>` を指定する（2点比較。3点比較 `...` は使わない）。
- plan ファイル（`plans/*.md` など）がある場合は 2段階目のレビューで使う。plan が無い場合は 1段階目のみで完結させ、その旨を `review.json` の `planPath: null` として明示し、レポートにもその旨が表示される。

## 手順（この順に厳守）

### Step 0: hunk マニフェスト生成

```bash
node ~/.claude/skills/diff-review-report/scripts/diff-manifest.mjs \
  --base HEAD --cwd <repo-path> --out /tmp/review-<slug>/hunks.json
```

これで各 hunk に `h001` 形式の安定IDが振られる。**以降のレビューは必ずこのIDを参照する。**
全体像をつかみたいときは `--list` で人間可読の1行サマリ（ID / ファイル / ヘッダ / +N -N）を確認できる。

### Step 1: plan 非開示レビュー（忖度対策の要）

- Agent tool でサブエージェントを起動する。**このサブエージェントには plan ファイルの内容・パス・存在を一切渡してはならない。** 「これは承認済みの計画に沿った実装だ」といった文脈も渡さない。
- 渡すもの:
  - `hunks.json` の絶対パス
  - リポジトリの絶対パス
  - 「この差分だけを見て、コードとして妥当かを判断せよ」という指示
  - `references/review-rules.md` を読ませる指示
- 出力: `/tmp/review-<slug>/blind.json`（スキーマは `references/review-schema.md`）。
- 規模が大きい場合は観点別（正しさ / 設計・結合 / テスト / セキュリティ）に複数エージェントを並列起動し、結果をマージしてよい。

### Step 2: plan 照合レビュー

- 別のサブエージェントに **plan ファイルと `blind.json` の両方**を渡す。役割は3つ:
  1. `blind.json` の各指摘を `planVerdict` で仕分ける — `kept`（planを読んでも指摘は有効）/ `demoted`（planの意図的な決定であり指摘としては弱い）/ `resolved`（planに照らすと誤読だった）。
  2. **`demoted` は削除せず残す。** 「planに則っているから」を理由に指摘を消してよいのは `resolved` のときだけ。demoted には `planNote` に理由を書き、レポートには残す。
  3. plan を読まないと気づけない指摘（plan項目の未実装、planからの逸脱、planが触れていない副作用）を新規に追加する。
- 出力: `/tmp/review-<slug>/review.json`（スキーマは `references/review-schema.md`）。

### Step 3: HTML生成

```bash
node ~/.claude/skills/diff-review-report/scripts/build-report.mjs \
  --hunks /tmp/review-<slug>/hunks.json \
  --review /tmp/review-<slug>/review.json \
  --out <レポート出力先>.html
```

出力先は既定でリポジトリ直下の `review-<slug>.html`。生成後、絶対パスを user に伝えて開いてもらう。
**gitignore されていない場所に出す場合は、コミットに混ぜないよう user に注意喚起する。**

## Codex CLI で 1段階目を回す場合（オプション）

`references/review-rules.md` を読ませたうえで read-only で実行する。1段階目は plan 非開示が前提なので、prompt にも plan の存在を書かない。

```bash
bunx @openai/codex exec --sandbox read-only \
  "references/review-rules.md の規範に従い、/tmp/review-<slug>/hunks.json の差分だけを見てコードとして妥当かを判断せよ。plan の内容は一切参照しない。"
```

- `--dangerously-bypass-approvals-and-sandbox` は**使わない**（未追跡ファイルが消えた事故があるため）。
- Codex には JSON ファイルを直接書かせず、Codex の標準出力を Claude 側で `references/review-schema.md` に沿った `review.json`（blind 相当）に整形する。

## やってはいけないこと

- hunk ID を推測で書かない（必ず `hunks.json` 由来）。
- 指摘のない「褒め」だけのグループ説明で埋めない。意図が読み取れないグループは `unclear: true` を立てる。
- HTML を LLM に直接書かせない（必ず `build-report.mjs` で生成する）。

## 参照

- `references/review-rules.md`: サブエージェントに読ませるレビュー規範（グループ化・並び順・severity基準・忖度禁止・推測禁止）。
- `references/review-schema.md`: `blind.json` / `review.json` のJSONスキーマと実例。
