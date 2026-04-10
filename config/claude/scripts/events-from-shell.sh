#!/usr/bin/env bash
# events-from-shell.sh - Emit meaningful shell commands for a given date as TSV.
#
# Output format (TSV): HH:MM\tshell\t-\t<command>
# Source: ~/.local/share/fish/fish_history (yaml-like)
#
# Filtering strategy (to keep the signal:noise ratio high):
#   - Only keep commands whose first word is in a whitelist of "meaningful" tools.
#   - Skip trivial commands (ls, cd, cat, which, ...).
#   - Dedupe consecutive identical commands.
#   - Truncate commands to 100 chars.

set -uo pipefail

TARGET_DATE="${1:-$(date -v-1d '+%Y-%m-%d')}"
NEXT_DATE=$(date -j -v+1d -f '%Y-%m-%d' "$TARGET_DATE" '+%Y-%m-%d')

DAY_START=$(date -j -f '%Y-%m-%d %H:%M:%S' "$TARGET_DATE 00:00:00" +%s)
DAY_END=$(date -j -f '%Y-%m-%d %H:%M:%S' "$NEXT_DATE 00:00:00" +%s)

HIST="$HOME/.local/share/fish/fish_history"
[ -f "$HIST" ] || exit 0

# Whitelist: first word must match one of these. Written to a temp file
# because BSD awk (macOS default) does not accept multi-line -v values.
ALLOWED_FILE=$(mktemp)
trap 'rm -f "$ALLOWED_FILE"' EXIT
cat > "$ALLOWED_FILE" <<'EOF'
git
nix
cargo
rustc
rustup
go
npm
pnpm
yarn
bun
deno
node
python
python3
uv
poetry
pip
pipx
make
just
task
docker
docker-compose
podman
gh
hub
claude
codex
ollama
kubectl
terraform
ansible
psql
sqlite3
ghq
brew
darwin-rebuild
home-manager
gcloud
aws
open
kaku
wezterm
rg
fd
hyperfine
EOF

# awk walks fish_history and extracts (when, cmd) pairs for matching dates & whitelist.
awk -v start="$DAY_START" -v end="$DAY_END" -v allowed_file="$ALLOWED_FILE" '
BEGIN {
  while ((getline line < allowed_file) > 0) if (line != "") ok[line] = 1
  close(allowed_file)
  cmd = ""; when = 0
}
/^- cmd: / {
  # "- cmd: foo" — content starts at column 8 (1-indexed).
  cmd = substr($0, 8)
  when = 0
  next
}
/^  when: / {
  # "  when: 1234" — value starts at column 9.
  when = substr($0, 9) + 0
  if (when >= start && when < end && cmd != "") {
    # first word of cmd
    first = cmd
    sub(/[[:space:]].*$/, "", first)
    if (first in ok) {
      # truncate
      if (length(cmd) > 100) cmd = substr(cmd, 1, 97) "..."
      printf "%d\t%s\n", when, cmd
    }
  }
  cmd = ""
}
' "$HIST" \
  | sort -n -u \
  | awk -F'\t' '
      BEGIN { prev = "" }
      {
        if ($2 == prev) next       # dedupe consecutive identicals
        prev = $2
        # convert unix time → HH:MM local
        cmd = "date -r " $1 " +%H:%M"
        cmd | getline hhmm
        close(cmd)
        printf "%s\tshell\t-\t%s\n", hhmm, $2
      }
    '
