#!/usr/bin/env bash
# Generate daily Markdown realtime logs from Claude Code and Codex raw session logs.
# Usage: generate-realtime-logs.sh [YYYY-MM-DD|today|yesterday] [output_dir]

set -euo pipefail

ARG="${1:-yesterday}"
OUTPUT_DIR="${2:-$HOME/MyLife/pages}"
CLAUDE_PROJECTS_DIR="${CLAUDE_PROJECTS_DIR:-$HOME/.claude/projects}"
CODEX_SESSIONS_DIR="${CODEX_SESSIONS_DIR:-$HOME/.codex/sessions}"

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

FILE_DATE=$(echo "$TARGET_DATE" | tr '-' '_')
START_ISO="${TARGET_DATE}T00:00:00"
END_ISO="${TARGET_DATE}T23:59:59"
START_EPOCH=$(date -j -f "%Y-%m-%d %H:%M:%S" "${TARGET_DATE} 00:00:00" "+%s")
END_EPOCH=$(date -j -f "%Y-%m-%d %H:%M:%S" "${TARGET_DATE} 23:59:59" "+%s")
START_UTC=$(date -j -u -r "$START_EPOCH" "+%Y-%m-%dT%H:%M:%S")
END_UTC=$(date -j -u -r "$END_EPOCH" "+%Y-%m-%dT%H:%M:%S")
TEMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/generate-realtime-logs.XXXXXX")

mkdir -p "$OUTPUT_DIR"
trap 'rm -rf "$TEMP_DIR"' EXIT

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

iso_to_local_time() {
  local iso_ts="$1"
  local raw="${iso_ts%%.*}"
  raw="${raw%Z}"

  if [[ "$iso_ts" == *Z ]]; then
    local epoch
    epoch=$(date -j -u -f "%Y-%m-%dT%H:%M:%S" "$raw" "+%s" 2>/dev/null) || {
      echo "??:??"
      return
    }
    date -r "$epoch" "+%H:%M" 2>/dev/null || echo "??:??"
  else
    date -j -f "%Y-%m-%dT%H:%M:%S" "$raw" "+%H:%M" 2>/dev/null || echo "??:??"
  fi
}

generate_claude_log() {
  local entries="$TEMP_DIR/claude.jsonl"
  local output_file="$OUTPUT_DIR/${FILE_DATE}_realtime-log.md"
  >"$entries"

  if [ ! -d "$CLAUDE_PROJECTS_DIR" ]; then
    log "Claude projects directory not found: $CLAUDE_PROJECTS_DIR"
    return
  fi

  while IFS= read -r -d '' session_file; do
    jq -c --arg start "$START_ISO" --arg end "$END_ISO" '
      def content_text:
        if (.message.content | type) == "string" then
          .message.content
        elif (.message.content | type) == "array" then
          [.message.content[]? | select(.type == "text") | .text] | join("\n")
        else
          ""
        end;

      select(.type == "user" or .type == "assistant") |
      select(.timestamp >= $start and .timestamp <= $end) |
      content_text as $content |
      select($content != "") |
      select(($content | contains("<system-reminder>") | not) and ($content | contains("<local-command>") | not)) |
      {
        timestamp: .timestamp,
        role: (.message.role // .type),
        content: $content[:1000]
      }
    ' "$session_file" >>"$entries" 2>/dev/null || true
  done < <(find "$CLAUDE_PROJECTS_DIR" -name "*.jsonl" -type f -print0 2>/dev/null)

  if [ ! -s "$entries" ]; then
    log "Claude realtime-log: no entries for $TARGET_DATE"
    return
  fi

  local tmp_output="$TEMP_DIR/claude.md"
  cat >"$tmp_output" <<EOF
---
type: realtime-log
date: $FILE_DATE
---

# Claude Code リアルタイムログ - $FILE_DATE

EOF

  jq -s -c 'sort_by(.timestamp)[]' "$entries" | while IFS= read -r entry; do
    local timestamp role content role_label msg_time
    timestamp=$(echo "$entry" | jq -r '.timestamp')
    role=$(echo "$entry" | jq -r '.role')
    content=$(echo "$entry" | jq -r '.content')
    msg_time=$(iso_to_local_time "$timestamp")

    if [ "$role" = "user" ]; then
      role_label="ユーザー"
    else
      role_label="Claude"
    fi

    {
      echo ""
      echo "**${role_label}** (${msg_time}):"
      echo ""
      echo "$content"
      echo ""
      echo "---"
    } >>"$tmp_output"
  done

  mv "$tmp_output" "$output_file"
  log "Claude realtime-log regenerated: $output_file"
}

generate_codex_log() {
  local entries="$TEMP_DIR/codex.jsonl"
  local output_file="$OUTPUT_DIR/${FILE_DATE}_codex-realtime-log.md"
  >"$entries"

  if [ ! -d "$CODEX_SESSIONS_DIR" ]; then
    log "Codex sessions directory not found: $CODEX_SESSIONS_DIR"
    return
  fi

  while IFS= read -r -d '' session_file; do
    jq -c --arg start "${START_UTC}Z" --arg end "${END_UTC}Z" '
      select(.type == "event_msg") |
      select(.payload.type == "user_message" or .payload.type == "agent_message") |
      select(.timestamp >= $start and .timestamp <= $end) |
      select(.payload.message != null and .payload.message != "") |
      {
        timestamp: .timestamp,
        role: .payload.type,
        content: .payload.message[:1000]
      }
    ' "$session_file" >>"$entries" 2>/dev/null || true
  done < <(find "$CODEX_SESSIONS_DIR" -name "rollout-*.jsonl" -type f -print0 2>/dev/null)

  if [ ! -s "$entries" ]; then
    log "Codex realtime-log: no entries for $TARGET_DATE"
    return
  fi

  local tmp_output="$TEMP_DIR/codex.md"
  cat >"$tmp_output" <<EOF
---
type: realtime-log
agent: codex
date: $FILE_DATE
---

# Codex リアルタイムログ - $FILE_DATE

EOF

  jq -s -c 'sort_by(.timestamp)[]' "$entries" | while IFS= read -r entry; do
    local timestamp role content role_label msg_time
    timestamp=$(echo "$entry" | jq -r '.timestamp')
    role=$(echo "$entry" | jq -r '.role')
    content=$(echo "$entry" | jq -r '.content')
    msg_time=$(iso_to_local_time "$timestamp")

    case "$role" in
    user_message) role_label="ユーザー" ;;
    agent_message) role_label="Codex" ;;
    *) continue ;;
    esac

    {
      echo ""
      echo "**${role_label}** (${msg_time}):"
      echo ""
      echo "$content"
      echo ""
      echo "---"
    } >>"$tmp_output"
  done

  mv "$tmp_output" "$output_file"
  log "Codex realtime-log regenerated: $output_file"
}

generate_claude_log
generate_codex_log
