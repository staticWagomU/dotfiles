#!/bin/bash
# Codex AI日誌 自動生成トリガー セットアップスクリプト
# Usage: setup-codex-journal-trigger.sh [install|uninstall|status|restart|test]

set -euo pipefail

SCRIPT_DIR="$HOME/.claude/scripts"
PLIST_NAME="com.user.codex-journal-trigger.plist"
PLIST_SRC="$SCRIPT_DIR/$PLIST_NAME"
PLIST_DST="$HOME/Library/LaunchAgents/$PLIST_NAME"
LOG_FILE="/tmp/auto-codex-journal.log"
ERROR_LOG="/tmp/auto-codex-journal.error.log"
STATE_FILE="$HOME/.codex/watcher-state/last-journal-date"

log() {
  echo "[setup] $1"
}

check_dependencies() {
  local missing=()
  command -v jq &>/dev/null || missing+=(jq)
  command -v sqlite3 &>/dev/null || missing+=(sqlite3)
  command -v claude &>/dev/null || missing+=(claude)

  if [ ${#missing[@]} -gt 0 ]; then
    log "ERROR: Missing dependencies: ${missing[*]}"
    exit 1
  fi
}

install() {
  log "Installing Codex Journal Trigger..."

  check_dependencies

  chmod +x "$SCRIPT_DIR/auto-codex-journal.sh"
  chmod +x "$SCRIPT_DIR/extract-codex-journal-data.sh"
  log "Made scripts executable"

  mkdir -p "$HOME/Library/LaunchAgents"

  sed "s|~|$HOME|g" "$PLIST_SRC" >"$PLIST_DST"
  log "Installed plist to $PLIST_DST"

  launchctl unload "$PLIST_DST" 2>/dev/null || true
  launchctl load "$PLIST_DST"
  log "Loaded LaunchAgent"

  mkdir -p "$HOME/.codex/watcher-state"
  mkdir -p "$HOME/MyLife/pages"
  log "Created required directories"

  log ""
  log "Installation complete!"
  log "The trigger runs daily at 00:05 (or on first wake after midnight)."
  log ""
  log "Check status: $0 status"
  log "Manual test:  $0 test"
  log "View logs:    tail -f $LOG_FILE"
}

uninstall() {
  log "Uninstalling Codex Journal Trigger..."

  if [ -f "$PLIST_DST" ]; then
    launchctl unload "$PLIST_DST" 2>/dev/null || true
    log "Unloaded LaunchAgent"
  fi

  rm -f "$PLIST_DST"
  log "Removed plist file"

  log ""
  log "Uninstallation complete!"
}

status() {
  log "Codex Journal Trigger Status"
  log "=============================="

  if launchctl list 2>/dev/null | grep -q "com.user.codex-journal-trigger"; then
    log "LaunchAgent: Loaded"
  else
    log "LaunchAgent: Not loaded"
  fi

  if [ -f "$PLIST_DST" ]; then
    log "Plist installed: Yes"
  else
    log "Plist installed: No"
  fi

  if [ -f "$STATE_FILE" ]; then
    log "Last run date: $(cat "$STATE_FILE")"
  else
    log "Last run date: Never"
  fi

  if [ -f "$LOG_FILE" ]; then
    log ""
    log "Recent logs:"
    tail -5 "$LOG_FILE" | sed 's/^/  /'
  fi

  if [ -f "$ERROR_LOG" ] && [ -s "$ERROR_LOG" ]; then
    log ""
    log "Recent errors:"
    tail -5 "$ERROR_LOG" | sed 's/^/  /'
  fi
}

restart() {
  log "Restarting Codex Journal Trigger..."

  if [ -f "$PLIST_DST" ]; then
    launchctl unload "$PLIST_DST" 2>/dev/null || true
    sleep 1
    launchctl load "$PLIST_DST"
    log "Restarted successfully"
  else
    log "ERROR: Trigger is not installed. Run: $0 install"
    exit 1
  fi
}

test_run() {
  log "Running manual test (yesterday's journal)..."

  check_dependencies

  # stateファイルを一時退避して強制実行
  local backup=""
  if [ -f "$STATE_FILE" ]; then
    backup=$(cat "$STATE_FILE")
    rm -f "$STATE_FILE"
  fi

  "$SCRIPT_DIR/auto-codex-journal.sh" || true

  # stateを復元（テスト実行で上書きされるのでそのまま）
  log ""
  log "Test complete. Check output in ~/MyLife/pages/"
}

usage() {
  cat <<EOF
Codex Journal Trigger Setup

Usage: $0 [command]

Commands:
  install    Install and start the trigger
  uninstall  Stop and remove the trigger
  status     Show current status
  restart    Restart the trigger
  test       Manually run journal generation for yesterday

Schedule:
  Runs daily at 00:05 JST. If the Mac is asleep at that time,
  it runs on the first wake after midnight.

Examples:
  $0 install   # Install and start
  $0 status    # Check if running
  $0 test      # Manual test run
EOF
}

case "${1:-}" in
install)
  install
  ;;
uninstall)
  uninstall
  ;;
status)
  status
  ;;
restart)
  restart
  ;;
test)
  test_run
  ;;
*)
  usage
  exit 1
  ;;
esac
