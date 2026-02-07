#!/bin/bash
# AI日誌用ログ抽出・整形スクリプト（ハイブリッド版）
# Usage: extract-journal-data.sh [YYYY-MM-DD|today|yesterday]
#
# データソース:
#   1. ~/.claude/history.jsonl - ユーザープロンプト
#   2. ~/.claude/projects/*/*.jsonl - セッション会話（user/assistant）

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
PROJECTS_DIR="$HOME/.claude/projects"

# タイムスタンプ範囲計算（JST）
START_TS=$(date -j -f "%Y-%m-%d %H:%M:%S" "${TARGET_DATE} 00:00:00" "+%s")000
END_TS=$(date -j -f "%Y-%m-%d %H:%M:%S" "${TARGET_DATE} 23:59:59" "+%s")999
# ISO8601形式の範囲（セッションファイル用）
START_ISO="${TARGET_DATE}T00:00:00"
END_ISO="${TARGET_DATE}T23:59:59"

# 一時ディレクトリ作成
mkdir -p "$TEMP_DIR"

# ログ抽出
HISTORY_FILE="$HOME/.claude/history.jsonl"
if [ ! -f "$HISTORY_FILE" ]; then
  echo '{"error": "history.jsonl not found"}' >&2
  exit 1
fi

# 対象日のログを抽出（history.jsonl）
RAW_LOGS="$TEMP_DIR/raw.jsonl"
cat "$HISTORY_FILE" | jq -c "select(.timestamp >= ${START_TS} and .timestamp <= ${END_TS})" >"$RAW_LOGS"

ENTRY_COUNT=$(wc -l <"$RAW_LOGS" | tr -d ' ')
if [ "$ENTRY_COUNT" -eq 0 ]; then
  echo '{"error": "no entries found", "date": "'"$TARGET_DATE"'"}' >&2
  exit 1
fi

# セッションファイルから会話を抽出
CONVERSATIONS="$TEMP_DIR/conversations.jsonl"
>"$CONVERSATIONS"

# history.jsonl から対象日のセッションIDを取得
SESSION_IDS=$(cat "$RAW_LOGS" | jq -r '.sessionId' | sort -u)

# 各セッションファイルから会話を抽出
for SESSION_ID in $SESSION_IDS; do
  # プロジェクトディレクトリ内のセッションファイルを検索
  SESSION_FILE=$(find "$PROJECTS_DIR" -name "${SESSION_ID}.jsonl" 2>/dev/null | head -1)
  if [ -n "$SESSION_FILE" ] && [ -f "$SESSION_FILE" ]; then
    # user/assistant メッセージを抽出（system-reminder等をフィルタリング）
    cat "$SESSION_FILE" | jq -c --arg start "$START_ISO" --arg end "$END_ISO" '
      select(.type == "user" or .type == "assistant") |
      select(.timestamp >= $start and .timestamp <= $end) |
      # system-reminder を含むメッセージをフィルタリング
      select(
        ((.message.content | type) == "string" and
         (.message.content | contains("<system-reminder>") | not) and
         (.message.content | contains("<local-command>") | not))
        or
        ((.message.content | type) == "array")
      ) |
      {
        session_id: .sessionId,
        type: .type,
        role: .message.role,
        content: (
          if (.message.content | type) == "string" then
            .message.content
          else
            # 配列の場合は text タイプのみ抽出（thinking, tool_use を除外）
            [.message.content[] | select(.type == "text") | .text] | join("\n")
          end
        ),
        timestamp: .timestamp
      }
    ' >>"$CONVERSATIONS" 2>/dev/null || true
  fi
done

# プロジェクト別・セッション別に構造化（会話データを含む）
STRUCTURED="$TEMP_DIR/structured.json"

# history.jsonl と conversations を結合して構造化
cat "$RAW_LOGS" | jq -s --slurpfile convs <(cat "$CONVERSATIONS" | jq -s '.' 2>/dev/null || echo '[]') '
  # 会話データをセッションIDでグループ化
  ($convs[0] // [] | group_by(.session_id) | map({key: .[0].session_id, value: .}) | from_entries) as $conv_map |

  group_by(.project) |
  map({
    project: .[0].project,
    project_name: (.[0].project | split("/") | last),
    sessions: (group_by(.sessionId) | map({
      session_id: .[0].sessionId,
      start_time: (.[0].timestamp / 1000 | floor),
      end_time: (.[-1].timestamp / 1000 | floor),
      entry_count: length,
      prompts: [.[].display | select(. != null and . != "")],
      conversations: ($conv_map[.[0].sessionId] // [] | map({
        role: .role,
        content: (
          if (.content | length) > 500 then
            (.content[0:500] + "...")
          else
            .content
          end
        ),
        timestamp: .timestamp
      }) | sort_by(.timestamp))
    }) | sort_by(.start_time)),
    total_entries: length
  }) |
  sort_by(.project_name)
' >"$STRUCTURED"

# サマリー統計を生成
SUMMARY="$TEMP_DIR/summary.json"
cat "$STRUCTURED" | jq '{
  date: "'"$TARGET_DATE"'",
  journal_path: "'"$JOURNAL_PATH"'",
  existing_file: (if "'"$([ -f "$JOURNAL_PATH" ] && echo "true" || echo "false")"'" == "true" then true else false end),
  total_projects: length,
  total_sessions: [.[].sessions | length] | add,
  total_entries: [.[].total_entries] | add,
  total_conversations: [.[].sessions[].conversations | length] | add,
  projects: [.[] | {
    name: .project_name,
    path: .project,
    sessions: (.sessions | length),
    entries: .total_entries,
    conversations: ([.sessions[].conversations | length] | add)
  }]
}' >"$SUMMARY"

# 最終出力（JSON形式）
echo "{"
echo '  "meta":'
cat "$SUMMARY"
echo ','
echo '  "data":'
cat "$STRUCTURED"
echo "}"
