#!/usr/bin/env bash
# events-build.sh - Collect events from all sources and idempotently append
# a "## 機械日報" section to the Obsidian daily note.
#
# Sources: events-from-git.sh, events-from-shell.sh, events-from-retrace.sh
# Diff   : events-diff.sh
#
# Idempotency:
#   - The section is wrapped in <!-- events:auto:start --> / <!-- events:auto:end -->
#   - On re-run, the old block is replaced (not appended again).
#
# Usage: events-build.sh [YYYY-MM-DD]
#   defaults to yesterday

set -uo pipefail

TARGET_DATE="${1:-$(date -v-1d '+%Y-%m-%d')}"
FILE_DATE=$(echo "$TARGET_DATE" | tr '-' '_')

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VAULT="$HOME/MyLife"
DAILY_NOTE="$VAULT/pages/${FILE_DATE}.md"

MARK_START="<!-- events:auto:start -->"
MARK_END="<!-- events:auto:end -->"

# Create daily note with frontmatter if missing (same shape as daily-harvest.sh).
if [ ! -f "$DAILY_NOTE" ]; then
  mkdir -p "$(dirname "$DAILY_NOTE")"
  cat > "$DAILY_NOTE" <<EOF
---
tags:
  - daily
  - $(echo "$TARGET_DATE" | cut -d- -f1-2)
date: $(echo "$TARGET_DATE" | tr '-' '/')
title: ${FILE_DATE}デイリーノート
---
EOF
fi

# Gather all source streams into a single TSV, then sort by HH:MM.
TMP=$(mktemp)
trap 'rm -f "$TMP" "$TMP.diff" "$TMP.section"' EXIT

bash "$SCRIPT_DIR/events-from-git.sh"     "$TARGET_DATE" >> "$TMP" 2>/dev/null || true
bash "$SCRIPT_DIR/events-from-shell.sh"   "$TARGET_DATE" >> "$TMP" 2>/dev/null || true
bash "$SCRIPT_DIR/events-from-retrace.sh" "$TARGET_DATE" >> "$TMP" 2>/dev/null || true

TOTAL=$(wc -l < "$TMP" | tr -d ' ')

# Also collect the diff bullets (may be empty).
bash "$SCRIPT_DIR/events-diff.sh" "$TARGET_DATE" > "$TMP.diff" 2>/dev/null || true
DIFF_LINES=$(wc -l < "$TMP.diff" | tr -d ' ')

# If absolutely nothing, skip (don't pollute the note with an empty section).
if [ "$TOTAL" -eq 0 ] && [ "$DIFF_LINES" -eq 0 ]; then
  exit 0
fi

# Build the new section.
{
  echo "$MARK_START"
  echo "## 機械日報"
  echo ""
  if [ "$DIFF_LINES" -gt 0 ]; then
    echo "### 注目ポイント"
    cat "$TMP.diff"
    echo ""
  fi
  if [ "$TOTAL" -gt 0 ]; then
    echo "### タイムライン"
    # Sort events by HH:MM, then format as markdown list rows.
    sort -t $'\t' -k1,1 "$TMP" | awk -F'\t' '
      {
        hhmm = $1; src = $2; ctx = $3; desc = $4
        if (ctx == "-" || ctx == "") {
          printf "- `%s` **%s**  %s\n", hhmm, src, desc
        } else {
          printf "- `%s` **%s**  *%s*  %s\n", hhmm, src, ctx, desc
        }
      }
    '
    echo ""
  fi
  echo "$MARK_END"
} > "$TMP.section"

# Idempotent replace: strip any existing block, then append fresh.
if grep -qF "$MARK_START" "$DAILY_NOTE"; then
  # Strip the marked block and any trailing blank lines that might remain.
  awk -v s="$MARK_START" -v e="$MARK_END" '
    BEGIN { skip = 0 }
    $0 == s { skip = 1; next }
    $0 == e { skip = 0; next }
    !skip { buf[NR] = $0 }
    END {
      # find last non-blank
      last = 0
      for (i = 1; i <= NR; i++) if (i in buf && buf[i] != "") last = i
      for (i = 1; i <= last; i++) if (i in buf) print buf[i]
    }
  ' "$DAILY_NOTE" > "$DAILY_NOTE.tmp"
  mv "$DAILY_NOTE.tmp" "$DAILY_NOTE"
fi

# Append with a blank line separator
{
  if [ -s "$DAILY_NOTE" ]; then
    # ensure a trailing newline in the existing file, then add a blank line
    tail -c1 "$DAILY_NOTE" | od -An -c | grep -q '\\n' || printf '\n' >> "$DAILY_NOTE"
    printf '\n'
  fi
  cat "$TMP.section"
} >> "$DAILY_NOTE"

echo "events-build: wrote $TOTAL events + $DIFF_LINES diff lines to $DAILY_NOTE" >&2
