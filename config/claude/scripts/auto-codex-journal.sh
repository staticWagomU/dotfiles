#!/bin/bash
# Codex AI日誌 自動生成トリガースクリプト
# launchdから毎日00:05にスケジュール実行される
# スリープ中に時刻を過ぎた場合はwake時に実行される
#
# 動作:
#   1. 最後に実行した日付を確認
#   2. 新しい日付なら前日分のCodex AI日誌を生成
#   3. claude -p で非対話的にジャーナルを生成

set -euo pipefail

STATE_FILE="$HOME/.codex/watcher-state/last-journal-date"
LOG_FILE="/tmp/auto-codex-journal.log"
JOURNAL_DIR="$HOME/MyLife/pages"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# 今日の日付
TODAY=$(date +%Y-%m-%d)
YESTERDAY=$(date -v-1d +%Y-%m-%d)

# 最後に実行した日付を取得
LAST_DATE=""
if [ -f "$STATE_FILE" ]; then
  LAST_DATE=$(cat "$STATE_FILE")
fi

# 同日に既に実行済みならスキップ
if [ "$LAST_DATE" = "$TODAY" ]; then
  log "Already ran today ($TODAY). Skipping."
  exit 0
fi

log "Date change detected: last=$LAST_DATE, today=$TODAY"
log "Generating Codex AI journal for $YESTERDAY"

# 前日分のCodexセッションが存在するか確認
EXTRACT_OUTPUT=$("$HOME/.claude/scripts/extract-codex-journal-data.sh" "$YESTERDAY" 2>/dev/null) || {
  log "No Codex sessions found for $YESTERDAY. Marking as done."
  echo "$TODAY" >"$STATE_FILE"
  exit 0
}

# 出力先の確認
FILE_YESTERDAY=$(echo "$YESTERDAY" | tr '-' '_')
OUTPUT_PATH="$JOURNAL_DIR/${FILE_YESTERDAY}_codex-ai-journals.md"
if [ -f "$OUTPUT_PATH" ]; then
  log "Journal already exists: $OUTPUT_PATH. Skipping generation."
  echo "$TODAY" >"$STATE_FILE"
  exit 0
fi

# claude CLI で非対話的にジャーナルを生成
log "Running claude -p for journal generation..."

PROMPT="以下のCodexログデータから、AI日誌を生成してください。

# 出力フォーマット

\`\`\`yaml
---
type: ai-journal
agent: codex
date: $FILE_YESTERDAY
projects: []  # プロジェクト名を列挙
total_sessions: 0
total_conversations: 0
---
\`\`\`

の後に以下のMarkdown構造で出力してください:

# Codex AI日誌 - $FILE_YESTERDAY

## サマリー
（全プロジェクト通じた1日の概要を2-3文で）

---

## プロジェクト: プロジェクト名
**パス**: パス

### セッション N [HH:MM - HH:MM]
**タイトル**: スレッドタイトル
**目的**: セッションの目的
**操作**: 実行した操作のリスト

#### 会話ハイライト
> **ユーザー**: 質問の要約
> **Codex**: 回答の要約

**要約**: セッションの要約

---

## 横断サマリー
### 本日の統計（テーブル）
### 主なトピック
### 学んだこと
### 課題・継続事項

# 制約
- タイムスタンプはUTCなのでJST(+9h)に変換してHH:MM表示
- start_time/end_timeはUNIX秒
- phase: final_answer の内容を優先的にハイライト
- 500文字で切り詰められた内容を補完しない
- Markdownのみ出力（説明文不要）

# データ

$EXTRACT_OUTPUT"

RESULT=$(claude -p "$PROMPT" \
  --model sonnet \
  --no-session-persistence \
  --allowedTools "" \
  --permission-mode bypassPermissions \
  --system-prompt "あなたはAI日誌ジェネレーターです。入力データからMarkdown形式のAI日誌のみを出力します。出力は必ず --- で始まるYAML frontmatterから開始してください。説明文、メタテキスト、コメント等は一切出力しないでください。純粋なMarkdownのみを出力してください。" \
  2>>"$LOG_FILE") || {
  log "ERROR: claude -p failed"
  echo "$TODAY" >"$STATE_FILE"
  exit 1
}

# 結果をファイルに保存
mkdir -p "$JOURNAL_DIR"
echo "$RESULT" >"$OUTPUT_PATH"
log "Journal saved to $OUTPUT_PATH"

# 実行日を記録
echo "$TODAY" >"$STATE_FILE"
log "Done. Marked $TODAY as processed."
