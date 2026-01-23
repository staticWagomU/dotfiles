#!/bin/bash
# Claude Code Journal Watcher セットアップスクリプト
# Usage: setup-journal-watcher.sh [install|uninstall|status|restart]

set -euo pipefail

SCRIPT_DIR="$HOME/.claude/scripts"
PLIST_NAME="com.user.claude-journal-watcher.plist"
PLIST_SRC="$SCRIPT_DIR/$PLIST_NAME"
PLIST_DST="$HOME/Library/LaunchAgents/$PLIST_NAME"
LOG_FILE="/tmp/claude-journal-watcher.log"
ERROR_LOG="/tmp/claude-journal-watcher.error.log"

log() {
  echo "[setup] $1"
}

check_dependencies() {
  if ! command -v jq &> /dev/null; then
    log "ERROR: jq is not installed. Please install it first:"
    log "  brew install jq"
    exit 1
  fi
}

install() {
  log "Installing Claude Journal Watcher..."

  check_dependencies

  # スクリプトに実行権限を付与
  chmod +x "$SCRIPT_DIR/watch-and-save.sh"
  log "Made watch-and-save.sh executable"

  # LaunchAgents ディレクトリを作成
  mkdir -p "$HOME/Library/LaunchAgents"

  # plist ファイル内の HOME を実際のパスに置換してコピー
  sed "s|~|$HOME|g" "$PLIST_SRC" > "$PLIST_DST"
  log "Installed plist to $PLIST_DST"

  # 既存のエージェントをアンロード（エラーは無視）
  launchctl unload "$PLIST_DST" 2>/dev/null || true

  # エージェントをロード
  launchctl load "$PLIST_DST"
  log "Loaded LaunchAgent"

  # 状態ディレクトリを作成
  mkdir -p "$HOME/.claude/watcher-state"
  mkdir -p "$HOME/Documents/MyLife/pages"
  log "Created required directories"

  log ""
  log "Installation complete!"
  log "The watcher will now run automatically on login."
  log ""
  log "Check status: $0 status"
  log "View logs: tail -f $LOG_FILE"
}

uninstall() {
  log "Uninstalling Claude Journal Watcher..."

  # エージェントをアンロード
  if [ -f "$PLIST_DST" ]; then
    launchctl unload "$PLIST_DST" 2>/dev/null || true
    log "Unloaded LaunchAgent"
  fi

  # plist ファイルを削除
  rm -f "$PLIST_DST"
  log "Removed plist file"

  log ""
  log "Uninstallation complete!"
  log "Note: State files in ~/.claude/watcher-state are preserved."
}

status() {
  log "Claude Journal Watcher Status"
  log "=============================="

  # LaunchAgent の状態を確認
  if launchctl list | grep -q "com.user.claude-journal-watcher"; then
    log "LaunchAgent: Running"
    local pid=$(launchctl list | grep "com.user.claude-journal-watcher" | awk '{print $1}')
    log "PID: $pid"
  else
    log "LaunchAgent: Not running"
  fi

  # plist ファイルの存在を確認
  if [ -f "$PLIST_DST" ]; then
    log "Plist installed: Yes"
  else
    log "Plist installed: No"
  fi

  # ログファイルの存在を確認
  if [ -f "$LOG_FILE" ]; then
    log ""
    log "Recent logs:"
    tail -5 "$LOG_FILE" | sed 's/^/  /'
  fi

  # エラーログを確認
  if [ -f "$ERROR_LOG" ] && [ -s "$ERROR_LOG" ]; then
    log ""
    log "Recent errors:"
    tail -5 "$ERROR_LOG" | sed 's/^/  /'
  fi
}

restart() {
  log "Restarting Claude Journal Watcher..."

  if [ -f "$PLIST_DST" ]; then
    launchctl unload "$PLIST_DST" 2>/dev/null || true
    sleep 1
    launchctl load "$PLIST_DST"
    log "Restarted successfully"
  else
    log "ERROR: Watcher is not installed. Run: $0 install"
    exit 1
  fi
}

usage() {
  cat << EOF
Claude Code Journal Watcher Setup

Usage: $0 [command]

Commands:
  install    Install and start the watcher
  uninstall  Stop and remove the watcher
  status     Show current status
  restart    Restart the watcher

Examples:
  $0 install   # Install and start
  $0 status    # Check if running
  $0 restart   # Restart after changes
EOF
}

# メイン処理
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
  *)
    usage
    exit 1
    ;;
esac
