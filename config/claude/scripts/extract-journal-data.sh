#!/bin/bash
# AI日誌用ログ抽出・整形スクリプト
# Usage: extract-journal-data.sh [YYYY-MM-DD|today|yesterday]

set -euo pipefail

# 引数解決
ARG="${1:-today}"
case "$ARG" in
  today)
    TARGET_DATE=$(date +%Y-%m-%d)
    ;;
  yesterday)
    TARGET_DATE=$(date -v-1d +%Y-%m-%d)
    ;;
  *)
    TARGET_DATE="$ARG"
    ;;
esac

# 出力先
JOURNAL_DIR="$HOME/Documents/MyLife/pages"
JOURNAL_PATH="$JOURNAL_DIR/${TARGET_DATE}_ai-journals.md"
TEMP_DIR="/tmp/ai-journal-${TARGET_DATE}"

# タイムスタンプ範囲計算（JST）
START_TS=$(date -j -f "%Y-%m-%d %H:%M:%S" "${TARGET_DATE} 00:00:00" "+%s")000
END_TS=$(date -j -f "%Y-%m-%d %H:%M:%S" "${TARGET_DATE} 23:59:59" "+%s")999

# 一時ディレクトリ作成
mkdir -p "$TEMP_DIR"

# ログ抽出
HISTORY_FILE="$HOME/.claude/history.jsonl"
if [ ! -f "$HISTORY_FILE" ]; then
  echo '{"error": "history.jsonl not found"}' >&2
  exit 1
fi

# 対象日のログを抽出
RAW_LOGS="$TEMP_DIR/raw.jsonl"
cat "$HISTORY_FILE" | jq -c "select(.timestamp >= ${START_TS} and .timestamp <= ${END_TS})" > "$RAW_LOGS"

ENTRY_COUNT=$(wc -l < "$RAW_LOGS" | tr -d ' ')
if [ "$ENTRY_COUNT" -eq 0 ]; then
  echo '{"error": "no entries found", "date": "'"$TARGET_DATE"'"}' >&2
  exit 1
fi

# プロジェクト別・セッション別に構造化
STRUCTURED="$TEMP_DIR/structured.json"
cat "$RAW_LOGS" | jq -s '
  group_by(.project) |
  map({
    project: .[0].project,
    project_name: (.[0].project | split("/") | last),
    sessions: (group_by(.sessionId) | map({
      session_id: .[0].sessionId,
      start_time: (.[0].timestamp / 1000 | floor),
      end_time: (.[-1].timestamp / 1000 | floor),
      entry_count: length,
      prompts: [.[].display | select(. != null and . != "")]
    }) | sort_by(.start_time)),
    total_entries: length
  }) |
  sort_by(.project_name)
' > "$STRUCTURED"

# サマリー統計を生成
SUMMARY="$TEMP_DIR/summary.json"
cat "$STRUCTURED" | jq '{
  date: "'"$TARGET_DATE"'",
  journal_path: "'"$JOURNAL_PATH"'",
  existing_file: (if "'"$([ -f "$JOURNAL_PATH" ] && echo "true" || echo "false")"'" == "true" then true else false end),
  total_projects: length,
  total_sessions: [.[].sessions | length] | add,
  total_entries: [.[].total_entries] | add,
  projects: [.[] | {
    name: .project_name,
    path: .project,
    sessions: (.sessions | length),
    entries: .total_entries
  }]
}' > "$SUMMARY"

# 最終出力（JSON形式）
echo "{"
echo '  "meta":'
cat "$SUMMARY"
echo ','
echo '  "data":'
cat "$STRUCTURED"
echo "}"
