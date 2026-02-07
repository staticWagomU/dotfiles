---
name: github-pr-review-operation
description: GitHub Pull Requestのレビュー操作を行うスキル。PR情報取得、差分確認、コメント取得・投稿、インラインコメント、コメント返信をghコマンドで実行する。PRレビュー、コードレビュー、PR操作が必要な時に使用。
---

<purpose>
GitHub CLI (`gh`) を使ったPRレビュー操作。
</purpose>

<constraints>
  <must>
    <rule>`gh` がインストール済みであること</rule>
    <rule>`gh auth login` で認証済みであること</rule>
    <rule>PR URL `https://github.com/OWNER/REPO/pull/NUMBER` から OWNER, REPO, NUMBER を抽出して使用すること</rule>
    <rule>`-F` (大文字) を数値パラメータ（`line`, `start_line`）に使用すること。`-f`だと文字列になりエラーになる</rule>
  </must>
</constraints>

<patterns>
  <pattern name="pr-info">
PR情報取得:
```bash
gh pr view NUMBER --repo OWNER/REPO --json title,body,author,state,baseRefName,headRefName,url
```
  </pattern>

  <pattern name="diff-with-line-numbers">
差分取得（行番号付き）:
```bash
gh pr diff NUMBER --repo OWNER/REPO | awk '
/^@@/ {
  match($0, /-([0-9]+)/, old)
  match($0, /\+([0-9]+)/, new)
  old_line = old[1]
  new_line = new[1]
  print $0
  next
}
/^-/ { printf "L%-4d     | %s\n", old_line++, $0; next }
/^\+/ { printf "     R%-4d| %s\n", new_line++, $0; next }
/^ / { printf "L%-4d R%-4d| %s\n", old_line++, new_line++, $0; next }
{ print }
'
```

出力例:
```
@@ -46,15 +46,25 @@ jobs:
L46   R46  |            prompt: |
L49       | -            （削除行）
     R49  | +            （追加行）
L50   R50  |              # レビューガイドライン
```

- `L数字`: LEFT(base)側の行番号 → インラインコメントで`side=LEFT`に使用
- `R数字`: RIGHT(head)側の行番号 → インラインコメントで`side=RIGHT`に使用
  </pattern>

  <pattern name="get-comments">
Issue Comments（PR全体へのコメント）:
```bash
gh api repos/OWNER/REPO/issues/NUMBER/comments --jq '.[] | {id, user: .user.login, created_at, body}'
```

Review Comments（コード行へのコメント）:
```bash
gh api repos/OWNER/REPO/pulls/NUMBER/comments --jq '.[] | {id, user: .user.login, path, line, created_at, body, in_reply_to_id}'
```
  </pattern>

  <pattern name="post-comment">
PRにコメント:
```bash
gh pr comment NUMBER --repo OWNER/REPO --body "コメント内容"
```
  </pattern>

  <pattern name="inline-comment">
まずhead commit SHAを取得:
```bash
gh api repos/OWNER/REPO/pulls/NUMBER --jq '.head.sha'
```

単一行コメント:
```bash
gh api repos/OWNER/REPO/pulls/NUMBER/comments \
  --method POST \
  -f body="コメント内容" \
  -f commit_id="COMMIT_SHA" \
  -f path="src/example.py" \
  -F line=15 \
  -f side=RIGHT
```

複数行コメント（10〜15行目）:
```bash
gh api repos/OWNER/REPO/pulls/NUMBER/comments \
  --method POST \
  -f body="コメント内容" \
  -f commit_id="COMMIT_SHA" \
  -f path="src/example.py" \
  -F line=15 \
  -f side=RIGHT \
  -F start_line=10 \
  -f start_side=RIGHT
```

注意点:
- `-F` (大文字): 数値パラメータ（`line`, `start_line`）に使用。`-f`だと文字列になりエラーになる
- `side`: `RIGHT`（追加行）または `LEFT`（削除行）
  </pattern>

  <pattern name="reply-to-comment">
コメントへ返信:
```bash
gh api repos/OWNER/REPO/pulls/NUMBER/comments/COMMENT_ID/replies \
  --method POST \
  -f body="返信内容"
```
`COMMENT_ID`はコメント取得で得た`id`を使用。
  </pattern>
</patterns>
