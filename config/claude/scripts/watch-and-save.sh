#!/bin/bash
# Claude Code セッション監視・自動保存スクリプト
# Usage: watch-and-save.sh [output_dir]
#
# 5秒ごとにセッションファイルを監視し、新規メッセージをMarkdownに追記
# 参考: https://zenn.dev/pepabo/articles/ffb79b5279f6ee

set -euo pipefail

# 設定
PROJECTS_DIR="$HOME/.claude/projects"
OUTPUT_DIR="${1:-$HOME/Documents/MyLife/pages}"
STATE_DIR="$HOME/.claude/watcher-state"
INTERVAL=5

# 状態ディレクトリ作成
mkdir -p "$STATE_DIR"
mkdir -p "$OUTPUT_DIR"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# ISO8601タイムスタンプをJST時刻に変換
iso_to_jst() {
  local iso_ts="$1"
  # macOS date コマンド用
  date -j -f "%Y-%m-%dT%H:%M:%S" "${iso_ts%%.*}" "+%H:%M" 2>/dev/null || echo "??:??"
}

# ISO8601タイムスタンプから日付を抽出
iso_to_date() {
  local iso_ts="$1"
  echo "${iso_ts%%T*}"
}

# メッセージ内容をフィルタリング
filter_content() {
  local content="$1"
  # system-reminder, local-command タグを除去
  echo "$content" | sed -E 's/<system-reminder>.*<\/system-reminder>//g' |
    sed -E 's/<local-command>.*<\/local-command>//g' |
    sed '/^$/d' |
    head -c 1000 # 長すぎるメッセージを切り詰め
}

# セッションファイルを処理
process_session_file() {
  local session_file="$1"
  local session_id=$(basename "$session_file" .jsonl)
  local state_file="$STATE_DIR/${session_id}.lines"

  # 前回処理した行数を取得
  local last_line=0
  if [ -f "$state_file" ]; then
    last_line=$(cat "$state_file")
  fi

  # 現在の行数を取得
  local current_lines=$(wc -l <"$session_file" | tr -d ' ')

  # 新規行がない場合はスキップ
  if [ "$current_lines" -le "$last_line" ]; then
    return
  fi

  # 新規行を処理
  local start_line=$((last_line + 1))
  tail -n +"$start_line" "$session_file" | while IFS= read -r line; do
    # user または assistant メッセージのみ処理
    local msg_type=$(echo "$line" | jq -r '.type // empty' 2>/dev/null)
    if [ "$msg_type" != "user" ] && [ "$msg_type" != "assistant" ]; then
      continue
    fi

    local timestamp=$(echo "$line" | jq -r '.timestamp // empty')
    local role=$(echo "$line" | jq -r '.message.role // empty')
    local content_type=$(echo "$line" | jq -r '.message.content | type' 2>/dev/null)

    # コンテンツを抽出
    local content=""
    if [ "$content_type" = "string" ]; then
      content=$(echo "$line" | jq -r '.message.content')
    elif [ "$content_type" = "array" ]; then
      # text タイプのみ抽出（thinking, tool_use を除外）
      content=$(echo "$line" | jq -r '[.message.content[] | select(.type == "text") | .text] | join("\n")')
    fi

    # 空のコンテンツやシステムメッセージをスキップ
    if [ -z "$content" ] || [ "$content" = "null" ]; then
      continue
    fi
    if [[ $content == *"<system-reminder>"* ]] || [[ $content == *"<local-command>"* ]]; then
      continue
    fi

    # 日付とファイルパスを決定
    local msg_date=$(iso_to_date "$timestamp")
    local msg_time=$(iso_to_jst "$timestamp")
    local output_file="$OUTPUT_DIR/${msg_date}_realtime-log.md"

    # ファイルが存在しない場合はヘッダーを追加
    if [ ! -f "$output_file" ]; then
      cat >"$output_file" <<EOF
---
type: realtime-log
date: $msg_date
---

# Claude Code リアルタイムログ - $msg_date

EOF
    fi

    # フィルタリングしたコンテンツを取得
    local filtered_content=$(filter_content "$content")

    # ロールに応じたフォーマットで追記
    local role_label=""
    if [ "$role" = "user" ]; then
      role_label="ユーザー"
    else
      role_label="Claude"
    fi

    # Markdownに追記
    echo "" >>"$output_file"
    echo "**${role_label}** (${msg_time}):" >>"$output_file"
    echo "" >>"$output_file"
    echo "$filtered_content" >>"$output_file"
    echo "" >>"$output_file"
    echo "---" >>"$output_file"

    log "Saved: $role_label message to $output_file"
  done

  # 処理済み行数を保存
  echo "$current_lines" >"$state_file"
}

# メインループ
main() {
  log "Claude Code session watcher started"
  log "Watching: $PROJECTS_DIR"
  log "Output: $OUTPUT_DIR"
  log "Interval: ${INTERVAL}s"

  while true; do
    # 全プロジェクトのセッションファイルを処理
    for project_dir in "$PROJECTS_DIR"/*/; do
      if [ -d "$project_dir" ]; then
        for session_file in "$project_dir"*.jsonl; do
          if [ -f "$session_file" ]; then
            process_session_file "$session_file"
          fi
        done
      fi
    done

    sleep "$INTERVAL"
  done
}

# シグナルハンドリング
cleanup() {
  log "Watcher stopped"
  exit 0
}
trap cleanup SIGINT SIGTERM

main
