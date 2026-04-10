#!/usr/bin/env bash
# todo-check.sh - Record whether todo.md was touched on the target date.
#
# Output (TSV to stdout): touched\t<0|1>
# Side effect: upsert a row in ~/.local/state/events/todo-history.tsv
#
# Strategy: compare todo.md's mtime date to TARGET_DATE.
#   mtime_date == TARGET_DATE  →  touched = 1
#   otherwise                  →  touched = 0
#
# Limitation: mtime only reveals the LAST modification. Running this script
# for a past date after the file has been touched again produces a stale
# answer. In the intended daily-harvest flow this is not an issue because
# events-review.sh runs immediately after the day it reports on.
#
# Usage: todo-check.sh [YYYY-MM-DD]
#   defaults to yesterday (matches events-build.sh convention)

set -uo pipefail

TARGET_DATE="${1:-$(date -v-1d '+%Y-%m-%d')}"

TODO_FILE="$HOME/MyLife/todo.md"
STATE_DIR="$HOME/.local/state/events"
STATE_FILE="$STATE_DIR/todo-history.tsv"

mkdir -p "$STATE_DIR"

# Missing file → treat as untouched (don't error; the rest of the pipeline
# should still produce a review).
if [ ! -f "$TODO_FILE" ]; then
  touched=0
else
  mtime_date=$(stat -f '%Sm' -t '%Y-%m-%d' "$TODO_FILE")
  if [ "$mtime_date" = "$TARGET_DATE" ]; then
    touched=1
  else
    touched=0
  fi
fi

# Upsert: drop any existing row for TARGET_DATE, append the fresh one.
# (Later callers can trust the file has exactly one row per date.)
if [ -f "$STATE_FILE" ]; then
  tmp=$(mktemp)
  awk -F'\t' -v d="$TARGET_DATE" '$1 != d' "$STATE_FILE" > "$tmp"
  mv "$tmp" "$STATE_FILE"
fi
printf "%s\t%s\n" "$TARGET_DATE" "$touched" >> "$STATE_FILE"

# Stdout: one-line TSV for callers (events-review.sh).
printf "touched\t%s\n" "$touched"
