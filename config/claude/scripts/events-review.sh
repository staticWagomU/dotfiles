#!/usr/bin/env bash
# events-review.sh - Build the ## レビュー section and insert before ## 機械日報.
#
# Sources:
#   - todo-check.sh        (today's binary ToDo status)
#   - existing events block in the daily note (for today's metrics)
#   - todo-history.tsv + daily-metrics.tsv (multi-day history)
#   - todo-suggest.sh      (candidate items via codex)
#
# Side effects:
#   - Upserts today's row in ~/.local/state/events/daily-metrics.tsv
#   - Inserts/replaces a <!-- review:auto:start -->...<!-- review:auto:end -->
#     block immediately before <!-- events:auto:start --> in the daily note.
#
# Must run AFTER events-build.sh for the same target date (this script
# parses the events block for today's metrics).
#
# Usage: events-review.sh [YYYY-MM-DD]
#   defaults to yesterday

set -uo pipefail

TARGET_DATE="${1:-$(date -v-1d '+%Y-%m-%d')}"
FILE_DATE=$(echo "$TARGET_DATE" | tr '-' '_')

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VAULT="$HOME/MyLife"
DAILY_NOTE="$VAULT/pages/${FILE_DATE}.md"
TODO_FILE="$VAULT/todo.md"

STATE_DIR="$HOME/.local/state/events"
TODO_HISTORY="$STATE_DIR/todo-history.tsv"
DAILY_METRICS="$STATE_DIR/daily-metrics.tsv"

MARK_START="<!-- review:auto:start -->"
MARK_END="<!-- review:auto:end -->"
EVENTS_START="<!-- events:auto:start -->"
EVENTS_END="<!-- events:auto:end -->"

mkdir -p "$STATE_DIR"

if [ ! -f "$DAILY_NOTE" ]; then
  echo "events-review: $DAILY_NOTE missing; run events-build.sh first" >&2
  exit 0
fi

# ─────────────────────────────────────────────────────────────
# 1. ToDo status (also upserts todo-history.tsv)
# ─────────────────────────────────────────────────────────────
TOUCHED=$(bash "$SCRIPT_DIR/todo-check.sh" "$TARGET_DATE" | awk -F'\t' '{print $2}')

# ─────────────────────────────────────────────────────────────
# 2. Parse today's metrics from the existing events block
# ─────────────────────────────────────────────────────────────
EVENTS_BLOCK=$(mktemp)
trap 'rm -f "$EVENTS_BLOCK" "$REVIEW_FILE" "$SUGGEST_OUT" "$HISTORY_JOINED" "$DAILY_NOTE.tmp"' EXIT

awk -v s="$EVENTS_START" -v e="$EVENTS_END" '
  $0 == s { inblk = 1; next }
  $0 == e { inblk = 0; next }
  inblk { print }
' "$DAILY_NOTE" > "$EVENTS_BLOCK"

# `grep -c` always writes the match count (even "0") but returns exit 1 on
# zero matches. Combining with `|| echo 0` causes the fallback to run AND
# append another "0", producing "00". Use `|| :` so only the exit code is
# swallowed.
COMMITS=$(grep -c '\*\*git\*\*' "$EVENTS_BLOCK" 2>/dev/null || :)
CAL_EVENTS=$(grep -c '\*\*cal\*\*' "$EVENTS_BLOCK" 2>/dev/null || :)

# Sum retrace focus durations. Each line has "NNm" or "NhMMm" right before "(".
# Python because BSD awk/grep regex is painful for multi-group capture.
FOCUS_MIN=$(grep '\*\*retrace\*\*' "$EVENTS_BLOCK" 2>/dev/null | python3 -c "
import sys, re
total = 0
for line in sys.stdin:
    m = re.search(r'(?:(\d+)h)?(\d+)m\s*\(', line)
    if m:
        h = int(m.group(1) or 0)
        mm = int(m.group(2))
        total += h * 60 + mm
print(total)
" 2>/dev/null || echo 0)

# Normalize any newlines/whitespace from grep -c | echo 0 fallback
COMMITS=$(echo "$COMMITS" | tr -d '[:space:]')
CAL_EVENTS=$(echo "$CAL_EVENTS" | tr -d '[:space:]')
FOCUS_MIN=$(echo "$FOCUS_MIN" | tr -d '[:space:]')
: "${COMMITS:=0}" "${CAL_EVENTS:=0}" "${FOCUS_MIN:=0}"

# ─────────────────────────────────────────────────────────────
# 3. Upsert today's metrics into daily-metrics.tsv
# ─────────────────────────────────────────────────────────────
if [ -f "$DAILY_METRICS" ]; then
  tmp=$(mktemp)
  awk -F'\t' -v d="$TARGET_DATE" '$1 != d' "$DAILY_METRICS" > "$tmp"
  mv "$tmp" "$DAILY_METRICS"
fi
printf "%s\t%s\t%s\t%s\n" "$TARGET_DATE" "$COMMITS" "$FOCUS_MIN" "$CAL_EVENTS" >> "$DAILY_METRICS"

# ─────────────────────────────────────────────────────────────
# 4. Join history: keep only days present in BOTH todo-history and metrics
# ─────────────────────────────────────────────────────────────
HISTORY_JOINED=$(mktemp)
if [ -f "$TODO_HISTORY" ] && [ -f "$DAILY_METRICS" ]; then
  awk -F'\t' '
    NR == FNR { touched[$1] = $2; next }
    $1 in touched { printf "%s\t%s\t%s\t%s\t%s\n", $1, touched[$1], $2, $3, $4 }
  ' "$TODO_HISTORY" "$DAILY_METRICS" | sort > "$HISTORY_JOINED"
fi
TOTAL_DAYS=$(wc -l < "$HISTORY_JOINED" 2>/dev/null | tr -d ' ')
: "${TOTAL_DAYS:=0}"

# Median helper: compute median of column $col for rows where $2 == $touched
compute_median() {
  local col=$1 touched_val=$2
  awk -F'\t' -v c="$col" -v t="$touched_val" '$2 == t { print $c }' "$HISTORY_JOINED" \
    | sort -n \
    | awk '
      { a[NR] = $1 }
      END {
        if (NR == 0) { print "-" }
        else if (NR % 2 == 1) { print a[(NR+1)/2] }
        else { print int((a[NR/2] + a[NR/2+1]) / 2) }
      }
    '
}

fmt_focus() {
  local m=$1
  if [ "$m" -ge 60 ]; then
    printf "%dh%02dm" $((m/60)) $((m%60))
  else
    printf "%dm" "$m"
  fi
}

# ─────────────────────────────────────────────────────────────
# 5. Collect ToDo suggestions (codex call; ~60s)
# ─────────────────────────────────────────────────────────────
SUGGEST_OUT=$(mktemp)
bash "$SCRIPT_DIR/todo-suggest.sh" "$TARGET_DATE" > "$SUGGEST_OUT" 2>/dev/null || true
SUGGEST_COUNT=$(wc -l < "$SUGGEST_OUT" | tr -d ' ')

# ─────────────────────────────────────────────────────────────
# 6. Build the review markdown block
# ─────────────────────────────────────────────────────────────
REVIEW_FILE=$(mktemp)
{
  echo "$MARK_START"
  echo "## レビュー"
  echo ""
  echo "### 今日の鏡"
  if [ "$TOUCHED" = "1" ]; then
    echo "- ToDo: ✅ 今日 todo.md に追記あり"
  else
    mtime=$(stat -f '%Sm' -t '%Y-%m-%d' "$TODO_FILE" 2>/dev/null || echo "?")
    echo "- ToDo: ❌ 今日 todo.md に追記なし (最終更新 $mtime)"
  fi
  focus_str=$(fmt_focus "$FOCUS_MIN")
  echo "- 実績: git commits ${COMMITS} / focus time ${focus_str} / calendar ${CAL_EVENTS} 件"
  echo ""

  echo "### 直近の対比"
  if [ "$TOTAL_DAYS" -lt 3 ]; then
    needed=$((3 - TOTAL_DAYS))
    echo "_履歴蓄積中 (あと ${needed} 日、現在 ${TOTAL_DAYS} 日分)_"
  else
    YES_DAYS=$(awk -F'\t' '$2 == 1' "$HISTORY_JOINED" | wc -l | tr -d ' ')
    NO_DAYS=$(awk -F'\t' '$2 == 0' "$HISTORY_JOINED" | wc -l | tr -d ' ')
    yes_commits=$(compute_median 3 1)
    yes_focus=$(compute_median 4 1)
    no_commits=$(compute_median 3 0)
    no_focus=$(compute_median 4 0)
    yes_focus_str=$([ "$yes_focus" = "-" ] && echo "-" || fmt_focus "$yes_focus")
    no_focus_str=$([ "$no_focus" = "-" ] && echo "-" || fmt_focus "$no_focus")
    echo "- ToDo あり日 (${YES_DAYS} 日): commits 中央値 ${yes_commits}, focus 中央値 ${yes_focus_str}"
    echo "- ToDo なし日 (${NO_DAYS} 日): commits 中央値 ${no_commits}, focus 中央値 ${no_focus_str}"
  fi
  echo ""

  echo "### todo.md に追加すべき候補 (${SUGGEST_COUNT}件)"
  if [ "$SUGGEST_COUNT" -gt 0 ]; then
    while IFS=$'\t' read -r todo_line source snippet; do
      [ -z "$todo_line" ] && continue
      echo "- \`${todo_line}\`"
      echo "  > ${source}: ${snippet}"
    done < "$SUGGEST_OUT"
  else
    echo "_候補なし_"
  fi
  echo ""
  echo "$MARK_END"
} > "$REVIEW_FILE"

# ─────────────────────────────────────────────────────────────
# 7. Insert/replace review block before events block
# ─────────────────────────────────────────────────────────────
awk -v ms="$MARK_START" -v me="$MARK_END" -v es="$EVENTS_START" \
    -v review_file="$REVIEW_FILE" '
BEGIN {
  while ((getline line < review_file) > 0) review[++rcnt] = line
  close(review_file)
  skip = 0
  expect_blank = 0
  inserted = 0
}
{
  # Skip any existing review block lines
  if ($0 == ms) { skip = 1; next }
  if ($0 == me) { skip = 0; expect_blank = 1; next }
  if (skip) next
  # Swallow exactly one blank line that used to follow the old review block
  if (expect_blank) {
    expect_blank = 0
    if ($0 == "") next
  }

  # Insert review just before the events marker
  if ($0 == es && !inserted) {
    for (i = 1; i <= rcnt; i++) print review[i]
    print ""
    inserted = 1
  }
  print
}
END {
  if (!inserted) {
    print ""
    for (i = 1; i <= rcnt; i++) print review[i]
  }
}
' "$DAILY_NOTE" > "$DAILY_NOTE.tmp"
mv "$DAILY_NOTE.tmp" "$DAILY_NOTE"

echo "events-review: wrote review section with ${SUGGEST_COUNT} suggestions to $DAILY_NOTE" >&2
