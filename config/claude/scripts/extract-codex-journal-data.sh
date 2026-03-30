#!/bin/bash
# Codex AI日誌用ログ抽出・整形スクリプト
# Usage: extract-codex-journal-data.sh [YYYY-MM-DD|today|yesterday]
#
# データソース:
#   1. ~/.codex/state_5.sqlite - スレッドメタデータ（cwd, title, timestamps）
#   2. ~/.codex/sessions/**/rollout-*.jsonl - セッション会話（user_message/agent_message）

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
JOURNAL_DIR="$HOME/MyLife/pages"
FILE_DATE=$(echo "$TARGET_DATE" | tr '-' '_')
JOURNAL_PATH="$JOURNAL_DIR/${FILE_DATE}_codex-ai-journals.md"
TEMP_DIR="/tmp/codex-journal-${TARGET_DATE}"
SESSIONS_DIR="$HOME/.codex/sessions"
STATE_DB="$HOME/.codex/state_5.sqlite"

# JST日付の開始・終了をUTC ISO8601に変換
# JST 00:00:00 = UTC前日 15:00:00, JST 23:59:59 = UTC当日 14:59:59
START_EPOCH=$(date -j -f "%Y-%m-%d %H:%M:%S" "${TARGET_DATE} 00:00:00" "+%s")
END_EPOCH=$(date -j -f "%Y-%m-%d %H:%M:%S" "${TARGET_DATE} 23:59:59" "+%s")
START_UTC=$(date -j -u -r "$START_EPOCH" "+%Y-%m-%dT%H:%M:%S")
END_UTC=$(date -j -u -r "$END_EPOCH" "+%Y-%m-%dT%H:%M:%S")

# 一時ディレクトリ作成
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"

if [ ! -f "$STATE_DB" ]; then
  echo '{"error": "state_5.sqlite not found"}' >&2
  exit 1
fi

# state_5.sqliteから対象日のスレッドを取得（epoch秒で比較）
THREADS_JSON="$TEMP_DIR/threads.json"
sqlite3 -json "$STATE_DB" "
  SELECT id, title, cwd, created_at, updated_at, model, first_user_message
  FROM threads
  WHERE updated_at >= ${START_EPOCH} AND created_at <= ${END_EPOCH}
  ORDER BY created_at ASC
" >"$THREADS_JSON" 2>/dev/null || echo '[]' >"$THREADS_JSON"

THREAD_COUNT=$(jq 'length' "$THREADS_JSON")
if [ "$THREAD_COUNT" -eq 0 ]; then
  echo '{"error": "no entries found", "date": "'"$TARGET_DATE"'"}' >&2
  exit 1
fi

# 各スレッドのrolloutファイルから会話を抽出
CONVERSATIONS="$TEMP_DIR/conversations.jsonl"
>"$CONVERSATIONS"

jq -r '.[].id' "$THREADS_JSON" | while read -r thread_id; do
  # rolloutファイルを検索（ファイル名にthread_idが含まれる）
  rollout_file=$(find "$SESSIONS_DIR" -name "*${thread_id}*.jsonl" -type f 2>/dev/null | head -1)
  if [ -z "$rollout_file" ] || [ ! -f "$rollout_file" ]; then
    continue
  fi

  # user_message/agent_messageイベントを抽出（UTC時刻範囲でフィルタ）
  jq -c --arg start "${START_UTC}" --arg end "${END_UTC}" --arg tid "$thread_id" '
    select(.type == "event_msg") |
    select(.payload.type == "user_message" or .payload.type == "agent_message") |
    select(.timestamp >= ($start + "Z") and .timestamp <= ($end + "Z")) |
    select(.payload.message != null and .payload.message != "") |
    {
      thread_id: $tid,
      role: (if .payload.type == "user_message" then "user" else "assistant" end),
      content: (if (.payload.message | length) > 500 then (.payload.message[:500] + "...") else .payload.message end),
      timestamp: .timestamp,
      phase: (.payload.phase // null)
    }
  ' "$rollout_file" >>"$CONVERSATIONS" 2>/dev/null || true
done

# プロジェクト別・セッション別に構造化
STRUCTURED="$TEMP_DIR/structured.json"

jq --slurpfile convs <(jq -s '.' "$CONVERSATIONS" 2>/dev/null || echo '[]') '
  # threads.json は sqlite3 -json の出力で既にJSON配列のため -s 不要
  # 会話データをthread_idでグループ化
  ($convs[0] // [] | group_by(.thread_id) | map({key: .[0].thread_id, value: .}) | from_entries) as $conv_map |

  # スレッドをcwd(プロジェクト)でグループ化
  group_by(.cwd) |
  map({
    project: .[0].cwd,
    project_name: (.[0].cwd | split("/") | last),
    sessions: ([.[] | {
      session_id: .id,
      title: .title,
      start_time: .created_at,
      end_time: .updated_at,
      model: .model,
      entry_count: 1,
      prompts: [.first_user_message | select(. != null and . != "")],
      conversations: ($conv_map[.id] // [] | map({
        role: .role,
        content: .content,
        timestamp: .timestamp,
        phase: .phase
      }) | sort_by(.timestamp))
    }] | sort_by(.start_time)),
    total_entries: length
  }) |
  sort_by(.project_name)
' "$THREADS_JSON" >"$STRUCTURED"

# サマリー統計を生成
SUMMARY="$TEMP_DIR/summary.json"
jq '{
  date: "'"$TARGET_DATE"'",
  agent: "codex",
  journal_path: "'"$JOURNAL_PATH"'",
  existing_file: '"$([ -f "$JOURNAL_PATH" ] && echo "true" || echo "false")"',
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
}' "$STRUCTURED" >"$SUMMARY"

# 最終出力（JSON形式）
echo "{"
echo '  "meta":'
cat "$SUMMARY"
echo ','
echo '  "data":'
cat "$STRUCTURED"
echo "}"
