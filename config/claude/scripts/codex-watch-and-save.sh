#!/bin/bash
# Codex セッション監視・自動保存スクリプト
# Usage: codex-watch-and-save.sh [output_dir]
#
# 5秒ごとにCodexセッションファイルを監視し、新規メッセージをMarkdownに追記
# Claude Code版 watch-and-save.sh と同じフォーマットで出力

set -euo pipefail

# 設定
SESSIONS_DIR="$HOME/.codex/sessions"
OUTPUT_DIR="${1:-$HOME/MyLife/pages}"
STATE_DIR="$HOME/.codex/watcher-state"
INTERVAL=5

# 状態ディレクトリ作成
mkdir -p "$STATE_DIR"
mkdir -p "$OUTPUT_DIR"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# ISO8601タイムスタンプをJST時刻(HH:MM)に変換
iso_to_jst_time() {
  local iso_ts="$1"
  # Zulu(UTC)をJSTに変換: macOS date
  local epoch
  epoch=$(date -j -u -f "%Y-%m-%dT%H:%M:%S" "${iso_ts%%.*}" "+%s" 2>/dev/null) || {
    echo "??:??"
    return
  }
  date -r "$epoch" "+%H:%M" 2>/dev/null || echo "??:??"
}

# ISO8601タイムスタンプからJST日付(YYYY_MM_DD)を抽出
iso_to_jst_date() {
  local iso_ts="$1"
  local epoch
  epoch=$(date -j -u -f "%Y-%m-%dT%H:%M:%S" "${iso_ts%%.*}" "+%s" 2>/dev/null) || {
    echo "${iso_ts%%T*}" | tr '-' '_'
    return
  }
  date -r "$epoch" "+%Y_%m_%d" 2>/dev/null || echo "${iso_ts%%T*}" | tr '-' '_'
}

# セッションファイルを処理
process_session_file() {
  local session_file="$1"
  local session_name
  session_name=$(basename "$session_file" .jsonl)
  local state_file="$STATE_DIR/${session_name}.lines"

  # 前回処理した行数を取得
  local last_line=0
  if [ -f "$state_file" ]; then
    last_line=$(cat "$state_file")
  fi

  # 現在の行数を取得
  local current_lines
  current_lines=$(wc -l <"$session_file" | tr -d ' ')

  # 新規行がない場合はスキップ
  if [ "$current_lines" -le "$last_line" ]; then
    return
  fi

  # 新規行をjqで一括抽出（行ごとのecho|jqパイプは大行で不安定なため）
  local start_line=$((last_line + 1))
  local extracted
  extracted=$(tail -n +"$start_line" "$session_file" | jq -r '
    select(.type == "event_msg") |
    select(.payload.type == "user_message" or .payload.type == "agent_message") |
    select(.payload.message != null and .payload.message != "") |
    [.timestamp, .payload.type, (.payload.message | gsub("\n"; "\\n") | .[:1000])] |
    join("\t")
  ' 2>/dev/null) || true

  if [ -z "$extracted" ]; then
    # 処理済み行数を保存して終了
    echo "$current_lines" >"$state_file"
    return
  fi

  echo "$extracted" | while IFS=$'\t' read -r timestamp payload_type content; do
    # タブ区切りが壊れた行をスキップ
    if [ -z "$timestamp" ] || [ -z "$payload_type" ] || [ -z "$content" ]; then
      continue
    fi

    local role_label=""
    case "$payload_type" in
    user_message)   role_label="ユーザー" ;;
    agent_message)  role_label="Codex" ;;
    *)              continue ;;
    esac

    # エスケープされた改行を復元
    content=$(printf '%b' "$content")

    # JSTベースで日付・時刻を取得
    local msg_date
    msg_date=$(iso_to_jst_date "$timestamp")
    local msg_time
    msg_time=$(iso_to_jst_time "$timestamp")
    local output_file="$OUTPUT_DIR/${msg_date}_codex-realtime-log.md"

    # ファイルが存在しない場合はヘッダーを追加
    if [ ! -f "$output_file" ]; then
      cat >"$output_file" <<EOF
---
type: realtime-log
agent: codex
date: $msg_date
---

# Codex リアルタイムログ - $msg_date

EOF
    fi

    # Markdownに追記
    {
      echo ""
      echo "**${role_label}** (${msg_time}):"
      echo ""
      echo "$content"
      echo ""
      echo "---"
    } >>"$output_file"

    log "Saved: $role_label message to $output_file"
  done

  # 処理済み行数を保存
  echo "$current_lines" >"$state_file"
}

# メインループ
main() {
  log "Codex session watcher started"
  log "Watching: $SESSIONS_DIR"
  log "Output: $OUTPUT_DIR"
  log "Interval: ${INTERVAL}s"

  while true; do
    # 全セッションファイルを再帰的に処理
    find "$SESSIONS_DIR" -name "rollout-*.jsonl" -type f 2>/dev/null | while read -r session_file; do
      process_session_file "$session_file"
    done

    sleep "$INTERVAL"
  done
}

# シグナルハンドリング
cleanup() {
  log "Codex watcher stopped"
  exit 0
}
trap cleanup SIGINT SIGTERM

main
