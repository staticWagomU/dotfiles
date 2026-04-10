#!/usr/bin/env bash
# events-from-git.sh - Emit git commit events for a given date as TSV.
#
# Output format (TSV): HH:MM\tgit\t<repo>\t<subject>
# Sort: caller's responsibility (events-build.sh sorts merged streams).
#
# Usage: events-from-git.sh [YYYY-MM-DD]
#   defaults to yesterday

set -uo pipefail

TARGET_DATE="${1:-$(date -v-1d '+%Y-%m-%d')}"
NEXT_DATE=$(date -j -v+1d -f '%Y-%m-%d' "$TARGET_DATE" '+%Y-%m-%d')

# Author filter: read from dotfiles repo (single source of truth)
AUTHOR_EMAIL=$(git -C "$HOME/dotfiles" config user.email 2>/dev/null || echo "")
[ -z "$AUTHOR_EMAIL" ] && AUTHOR_EMAIL="to6wa17@gmail.com"

# Where to look for git repositories
SEARCH_ROOTS=(
  "$HOME/dotfiles"
  "$HOME/dotvim"
  "$HOME/MyLife"
  "$HOME/bookstack"
  "$HOME/dev"
)

# Discover repos (depth-limited for speed)
REPOS=$(find "${SEARCH_ROOTS[@]}" -maxdepth 5 -name ".git" -type d 2>/dev/null | sed 's|/\.git$||')

while IFS= read -r repo; do
  [ -z "$repo" ] && continue
  name=$(basename "$repo")
  # tformat: (not format:) ensures trailing newline per entry, so concatenation is safe.
  git -C "$repo" log \
      --author="$AUTHOR_EMAIL" \
      --since="$TARGET_DATE 00:00" \
      --until="$NEXT_DATE 00:00" \
      --pretty=tformat:"%cI%x09${name}%x09%s" \
      --no-merges 2>/dev/null \
    | while IFS=$'\t' read -r iso repo_name subject; do
        [ -z "$iso" ] && continue
        # Extract HH:MM from the ISO date (already in local tz thanks to %cI)
        hhmm="${iso:11:5}"
        printf "%s\tgit\t%s\t%s\n" "$hhmm" "$repo_name" "$subject"
      done
done <<< "$REPOS"
