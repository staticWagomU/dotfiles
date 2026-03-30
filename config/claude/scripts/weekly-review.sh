#!/usr/bin/env bash
# weekly-review.sh
# 毎週月曜に先週分のFleeting Noteをレビューし、昇格候補を提示する
#
# トリガー: launchd StartCalendarInterval (月曜 06:00)
# - Mac起動中 → 月曜06:00に実行
# - Macスリープ中 → スリープ復帰直後に実行
# - 週1回のみ実行（冪等性保証）

set -euo pipefail

# === 設定 ===
VAULT="$HOME/MyLife"
STATE_DIR="$HOME/.claude/scripts"
LAST_RUN_FILE="$STATE_DIR/.last-weekly-review-date"
LOG_FILE="$STATE_DIR/weekly-review.log"
CLAUDE="$HOME/.local/bin/claude"

TODAY=$(date +%Y-%m-%d)
# ISO 週番号を取得（月曜始まり）
CURRENT_WEEK=$(date +%Y-W%V)

# === ヘルパー ===
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

notify() {
    osascript -e "display notification \"$1\" with title \"Weekly Review\"" 2>/dev/null || true
}

# === 冪等性チェック（同じ週には1回だけ） ===
if [ -f "$LAST_RUN_FILE" ] && [ "$(cat "$LAST_RUN_FILE")" = "$CURRENT_WEEK" ]; then
    exit 0
fi

log "=== Starting weekly review for last-week ($CURRENT_WEEK) ==="

# claude CLI の存在確認
if [ ! -x "$CLAUDE" ]; then
    log "ERROR: claude not found at $CLAUDE"
    notify "claude CLI が見つかりません"
    exit 1
fi

# Fleeting Note の存在確認（1件もなければスキップ）
FLEETING_COUNT=$(find "$VAULT/pages" -name '[0-9]*-*.md' -newer "$LAST_RUN_FILE" 2>/dev/null | wc -l | tr -d ' ')
if [ "$FLEETING_COUNT" -eq 0 ] && [ -f "$LAST_RUN_FILE" ]; then
    log "No new fleeting notes since last review, skipping"
    echo "$CURRENT_WEEK" > "$LAST_RUN_FILE"
    exit 0
fi

notify "先週分のWeekly Reviewを開始します..."

# === review ===
log "Running /review last-week..."
cd "$VAULT"
if "$CLAUDE" -p "/review last-week" \
    --model sonnet \
    --allowedTools "Read,Write,Edit,Glob,Grep,Bash" \
    >> "$LOG_FILE" 2>&1; then
    log "weekly review completed"
else
    log "WARNING: weekly review failed (exit code: $?)"
fi

# === 完了マーク ===
echo "$CURRENT_WEEK" > "$LAST_RUN_FILE"
log "=== Weekly review completed ==="
notify "Weekly Reviewが完了しました。レビュー結果を確認してください。"
