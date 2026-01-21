---
allowed-tools: Bash(cat:*), Bash(jq:*), Bash(date:*), Bash(mkdir:*), Bash(ls:*), Bash(~/.claude/scripts/*), Read, Write, Edit, AskUserQuestion
description: Generate AI journal from Claude Code history logs
argument-hint: [YYYY-MM-DD|today|yesterday]
model: sonnet
---

# AI日誌生成コマンド

## 概要

Claude Codeの履歴ログから、指定日のAI日誌を自動生成します。

## 引数

$ARGUMENTS

- `YYYY-MM-DD`: 指定した日付の日誌を生成（例: 2026-01-05）
- `today`: 本日の日誌を生成
- `yesterday`: 昨日の日誌を生成
- 引数なし: 本日の日誌を生成

## 出力先

`~/Documents/MyLife/pages/YYYY_MM_DD_ai-journal.md`

---

## Step 1: 前処理スクリプトでログを抽出

以下のコマンドを実行して、構造化されたログデータを取得:

```bash
~/.claude/scripts/extract-journal-data.sh "$ARGUMENTS"
```

このスクリプトは以下のJSON構造を出力します:
- `meta`: 日付、パス、統計情報
- `data`: プロジェクト別・セッション別の詳細データ

**エラー時**: スクリプトがエラーを返した場合は、ユーザーに通知して終了。

---

## Step 2: 既存ファイルの確認

`meta.existing_file` が `true` の場合、AskUserQuestion ツールで以下を確認:

1. **上書き**: 既存の内容を完全に置き換える
2. **追記**: 既存の内容の末尾に新しいセッション情報を追加
3. **キャンセル**: 処理を中止

---

## Step 3: 日誌の生成

抽出されたデータを元に、以下のフォーマットで日誌を生成:

### YAML Frontmatter
```yaml
---
type: ai-journal
date: YYYY-MM-DD
projects:
  - name: プロジェクト名
total_sessions: 合計セッション数
---
```

### Markdown本文

```markdown
# AI日誌 - YYYY-MM-DD

## サマリー
<!-- 全プロジェクト通じた1日の概要を2-3文で -->

---

## プロジェクト: プロジェクト名

**パス**: `パス`

### セッション N [HH:MM - HH:MM]
**目的**: セッションの目的（promptsから推測）
**操作**:
- 実行した操作のリスト（/clear, /status等のシステムコマンドは除外）

**要約**: セッションの要約

**本日の進捗**: プロジェクト全体の進捗

---

## 横断サマリー

### 本日の統計
| プロジェクト | セッション | 主な操作 | 備考 |
|-------------|-----------|---------|------|

### 主なトピック
- トピック1
- トピック2

### 課題・継続事項
- [ ] 課題1
- [ ] 課題2
```

---

## Step 4: ファイルの保存

```bash
mkdir -p ~/Documents/MyLife/pages
```

Write ツールを使用して `meta.journal_path` に保存。

---

## 注意事項

- プロジェクト名は `data[].project_name` を使用
- タイムスタンプはUNIX秒で提供されるので、JST (UTC+9) に変換して `HH:MM` 形式で表示
- `/clear`, `/status`, `/context` などのシステムコマンドは要約から除外
- 各プロンプトの内容から目的と操作を推測して記述
- セッションは時系列順に並んでいる

---

## 実行

上記のフローに従って、$ARGUMENTS の日付のAI日誌を生成してください。
