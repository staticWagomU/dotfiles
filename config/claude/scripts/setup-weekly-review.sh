#!/bin/bash
# Weekly Review 自動実行 セットアップスクリプト
# Usage: setup-weekly-review.sh [install|uninstall|status|restart|test]

set -euo pipefail

SCRIPT_DIR="$HOME/.claude/scripts"
PLIST_NAME="com.user.weekly-review.plist"
PLIST_SRC="$SCRIPT_DIR/$PLIST_NAME"
PLIST_DST="$HOME/Library/LaunchAgents/$PLIST_NAME"
LOG_FILE="$SCRIPT_DIR/weekly-review.log"
STATE_FILE="$SCRIPT_DIR/.last-weekly-review-date"

log() {
  echo "[setup] $1"
}

check_dependencies() {
  local missing=()
  command -v claude &>/dev/null || missing+=(claude)

  if [ ${#missing[@]} -gt 0 ]; then
    log "ERROR: Missing dependencies: ${missing[*]}"
    exit 1
  fi
}

install() {
  log "Installing Weekly Review Trigger..."

  check_dependencies

  chmod +x "$SCRIPT_DIR/weekly-review.sh"
  log "Made scripts executable"

  mkdir -p "$HOME/Library/LaunchAgents"

  sed "s|~|$HOME|g" "$PLIST_SRC" >"$PLIST_DST"
  log "Installed plist to $PLIST_DST"

  launchctl unload "$PLIST_DST" 2>/dev/null || true
  launchctl load "$PLIST_DST"
  log "Loaded LaunchAgent"

  mkdir -p "$HOME/MyLife/pages"
  log "Created required directories"

  log ""
  log "Installation complete!"
  log "The trigger runs every Monday at 06:00 (or on first wake after)."
  log ""
  log "Check status: $0 status"
  log "Manual test:  $0 test"
  log "View logs:    tail -f $LOG_FILE"
}

uninstall() {
  log "Uninstalling Weekly Review Trigger..."

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
  log "Weekly Review Trigger Status"
  log "=============================="

  if launchctl list 2>/dev/null | grep -q "com.user.weekly-review"; then
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
    log "Last run week: $(cat "$STATE_FILE")"
  else
    log "Last run week: Never"
  fi

  if [ -f "$LOG_FILE" ]; then
    log ""
    log "Recent logs:"
    tail -5 "$LOG_FILE" | sed 's/^/  /'
  fi

  local error_log="/tmp/weekly-review.error.log"
  if [ -f "$error_log" ] && [ -s "$error_log" ]; then
    log ""
    log "Recent errors:"
    tail -5 "$error_log" | sed 's/^/  /'
  fi
}

restart() {
  log "Restarting Weekly Review Trigger..."

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
  log "Running manual test (last week's review)..."

  check_dependencies

  # stateファイルを一時退避して強制実行
  local backup=""
  if [ -f "$STATE_FILE" ]; then
    backup=$(cat "$STATE_FILE")
    rm -f "$STATE_FILE"
  fi

  "$SCRIPT_DIR/weekly-review.sh" || true

  log ""
  log "Test complete. Check output in ~/MyLife/pages/"
}

usage() {
  cat <<EOF
Weekly Review Trigger Setup

Usage: $0 [command]

Commands:
  install    Install and start the trigger
  uninstall  Stop and remove the trigger
  status     Show current status
  restart    Restart the trigger
  test       Manually run weekly review for last week

Schedule:
  Runs every Monday at 06:00 JST. If the Mac is asleep at that time,
  it runs on the first wake after Monday 06:00.

Examples:
  $0 install   # Install and start
  $0 status    # Check if running
  $0 test      # Manual test run

Related commands:
  /review last-week   # Manual weekly review via Claude Code
  /promote <note>     # Promote a fleeting note to permanent
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
