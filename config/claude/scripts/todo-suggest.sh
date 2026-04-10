#!/usr/bin/env bash
# todo-suggest.sh - Extract TODO candidates from a day's notes using codex.
#
# Input:
#   - $HOME/MyLife/pages/YYYY_MM_DD.md      (user prose only, before first `## `)
#   - $HOME/MyLife/pages/YYYYMMDD*-*.md     (notes created that day, trimmed)
# Reference (for "do not duplicate"):
#   - $HOME/MyLife/todo.md                  (open tasks)
#   - $HOME/MyLife/todo.done.md             (completed — NEVER re-suggest)
#
# Output (TSV to stdout):
#   <todo_txt_line>\t<source_basename>\t<quoted_snippet>
#   - Max 8 rows.
#   - Empty output is valid (nothing actionable surfaced).
#
# Why codex (not claude): the user's established thought-partner workflow
# already uses `codex exec --skip-git-repo-check`; keeping the same tool
# avoids mental-model switching. Swap-out is cheap — only this file changes.
#
# Usage: todo-suggest.sh [YYYY-MM-DD]
#   defaults to yesterday

set -uo pipefail

TARGET_DATE="${1:-$(date -v-1d '+%Y-%m-%d')}"
FILE_DATE=$(echo "$TARGET_DATE" | tr '-' '_')
COMPACT_DATE=$(echo "$TARGET_DATE" | tr -d '-')

VAULT="$HOME/MyLife"
DAILY_NOTE="$VAULT/pages/${FILE_DATE}.md"
TODO_FILE="$VAULT/todo.md"
TODO_DONE_FILE="$VAULT/todo.done.md"

# Per-note trim length (bytes). Created notes can be huge (e.g. meeting
# transcripts from MeetJerky exceed 150KB), but TODO candidates almost
# always live in the opening section. A 2KB slice is enough context without
# blowing the codex context budget.
MAX_PER_NOTE=2000

# Extract the user-written prose from the daily note: everything between
# the end of the frontmatter and the first `## ` heading. Degrades gracefully
# if frontmatter or headings are missing.
extract_daily_prose() {
  local f="$1"
  [ -f "$f" ] || return 0
  awk '
    BEGIN { in_fm = 0; past_fm = 0 }
    /^---$/ {
      if (!past_fm) {
        if (!in_fm) { in_fm = 1; next }
        else { in_fm = 0; past_fm = 1; next }
      }
    }
    in_fm { next }
    past_fm && /^## / { exit }
    past_fm { print }
  ' "$f"
}

# Assemble the full prompt on stdout. Captured by caller via pipe.
build_prompt() {
  cat <<'HEADER'
You will extract at most 8 TODO candidates from the user's notes and output
them in todo.txt format.

All input is provided inline below. Do NOT invoke any tools or read any
additional files. Just analyze the text and respond with TSV lines.

STRICT RULES:
1. Only extract items that are EXPLICITLY stated in the notes as something
   to do, follow up on, buy, fix, contact, or remember for later. Do NOT
   infer tasks that are not written.
2. Do NOT duplicate items already present in todo.md (open tasks below).
3. Do NOT re-suggest items that appear in todo.done.md (already completed).
4. Output format: one TSV line per item. No preamble, no headers, no
   explanations, no markdown code fences. Only TSV lines.
   Each line has exactly three tab-separated fields:
     <todo_txt_line>	<source_file_basename>	<quoted_snippet>
5. <todo_txt_line> uses todo.txt format:
     YYYY-MM-DD <japanese_description> [+Project]
   where YYYY-MM-DD is the TARGET DATE shown below, and +Project is
   optional. Valid projects: +Blog, +Work, +Obsidian, +Personal. Omit if
   none applies.
6. Description is concise, verb-form, in Japanese. Aim for under 40 chars.
7. <quoted_snippet> is a short quote (max 40 chars) from the source that
   justifies the item. Japanese quote marks 「」 are fine.
8. Maximum 8 lines. If there are fewer than 8 clear candidates, output
   only as many as you can justify. If there are NO clear candidates,
   output nothing.

HEADER
  printf "TARGET DATE: %s\n\n" "$TARGET_DATE"

  printf "=== CURRENT todo.md (open tasks - do not duplicate) ===\n"
  if [ -f "$TODO_FILE" ]; then cat "$TODO_FILE"; else echo "(empty)"; fi
  printf "\n"

  printf "=== todo.done.md (already completed - NEVER re-suggest) ===\n"
  if [ -f "$TODO_DONE_FILE" ]; then cat "$TODO_DONE_FILE"; else echo "(empty)"; fi
  printf "\n"

  printf "=== NOTES FROM %s ===\n\n" "$TARGET_DATE"

  # 1. Daily note user prose (no trim — it's always small).
  if [ -f "$DAILY_NOTE" ]; then
    printf -- "--- %s (user diary, prose only) ---\n" "$(basename "$DAILY_NOTE")"
    extract_daily_prose "$DAILY_NOTE"
    printf "\n"
  fi

  # 2. Timestamp-prefixed notes created that day, trimmed per-file.
  # The glob pattern `YYYYMMDD*-*.md` inherently excludes auto-generated
  # names like `YYYY_MM_DD_ai-journal.md` (wrong separator & format).
  #
  # Trimming nuance: `head -c N` cuts by bytes and can slice a multi-byte
  # Japanese character in the middle, leaving a lone 0xE3 that breaks UTF-8
  # validation in downstream tools (codex rejects invalid UTF-8 prompts).
  # Piping through `iconv -c` drops any invalid sequence at the boundary.
  for note in "$VAULT/pages/${COMPACT_DATE}"*-*.md; do
    [ -f "$note" ] || continue
    [ -s "$note" ] || continue   # skip empty files
    printf -- "--- %s ---\n" "$(basename "$note")"
    head -c "$MAX_PER_NOTE" "$note" | iconv -c -f UTF-8 -t UTF-8 2>/dev/null
    printf "\n\n"
  done
}

# Capture only the agent's final message via -o. Everything else (tool
# traces, session metadata) is discarded.
LAST_MSG=$(mktemp)
trap 'rm -f "$LAST_MSG"' EXIT

build_prompt | codex exec \
  --skip-git-repo-check \
  --ephemeral \
  -s read-only \
  -C /tmp \
  -o "$LAST_MSG" \
  - >/dev/null 2>&1 || true

# Extract only well-shaped TSV lines (exactly 3 tab-separated fields).
# Defensive against codex occasionally wrapping output in prose or code
# fences despite the prompt's instructions.
if [ -s "$LAST_MSG" ]; then
  awk -F'\t' 'NF == 3 && $1 !~ /^```/ { print }' "$LAST_MSG" | head -n 8
fi
