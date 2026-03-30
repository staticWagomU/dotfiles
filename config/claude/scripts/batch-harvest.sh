#!/usr/bin/env bash
# batch-harvest.sh
# 全ての未処理 realtime-log を一括で harvest する
# 使い方: batch-harvest.sh [並列数(デフォルト2)]
set -euo pipefail

VAULT="$HOME/MyLife"
CLAUDE="$HOME/.local/bin/claude"
LOG_DIR="$HOME/.claude/scripts"
LOG_FILE="$LOG_DIR/batch-harvest.log"
DONE_DIR="$LOG_DIR/harvest-done"
MAX_JOBS="${1:-2}"

mkdir -p "$DONE_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

# 対象日のリスト（今日を除外）
TODAY=$(date +%Y_%m_%d)
DATES=$(cd "$VAULT/pages" && ls *_realtime-log.md 2>/dev/null \
    | sed 's/_realtime-log\.md$//' \
    | sort \
    | grep -v "$TODAY")

TOTAL=$(echo "$DATES" | wc -l | tr -d ' ')
log "=== Batch harvest started: $TOTAL dates, $MAX_JOBS parallel ==="

# 並列制御付きループ
running=0
for date in $DATES; do
    # 処理済みならスキップ
    if [ -f "$DONE_DIR/$date.done" ]; then
        log "SKIP  $date (already done)"
        continue
    fi

    # 並列数の上限に達したら待機
    while [ "$running" -ge "$MAX_JOBS" ]; do
        wait -n 2>/dev/null || true
        running=$((running - 1))
    done

    # バックグラウンドで harvest 実行
    (
        log "START $date"
        if cd "$VAULT" && "$CLAUDE" -p "/harvest $date" \
            --model sonnet \
            --allowedTools "Read,Write,Edit,Glob,Grep,Bash" \
            > "$LOG_DIR/harvest-$date.log" 2>&1; then
            touch "$DONE_DIR/$date.done"
            rm -f "$LOG_DIR/harvest-$date.log"
            log "DONE  $date"
        else
            log "FAIL  $date (exit code: $?)"
        fi
    ) &
    running=$((running + 1))
done

# 残りのジョブを待機
wait
log "=== Batch harvest finished ==="

# 集計
DONE_COUNT=$(ls "$DONE_DIR"/*.done 2>/dev/null | wc -l | tr -d ' ')
log "=== Result: $DONE_COUNT completed ==="

osascript -e "display notification \"$DONE_COUNT 日分の収穫が完了しました\" with title \"Batch Harvest\"" 2>/dev/null || true
