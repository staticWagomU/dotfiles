#!/usr/bin/env bash
# events-from-shell.sh - Emit meaningful shell commands for a given date as TSV.
#
# Output format (TSV): HH:MM\tshell\t<cwd-or-dash>\t<command>
#
# Sources (in priority order):
#   1. ~/.local/share/fish/events_cmdlog.tsv  (new, includes cwd)
#      — written by the fish_preexec hook in config/fish/config.fish.
#   2. ~/.local/share/fish/fish_history       (legacy fallback, no cwd)
#      — used only when the new log has zero entries for the target date,
#        so past days predating the hook still render.
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

CMDLOG="$HOME/.local/share/fish/events_cmdlog.tsv"
HIST="$HOME/.local/share/fish/fish_history"

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

# Shared post-processor: reads "<unix_ts>\t<cwd>\t<cmd>" on stdin and emits
# "HH:MM\tshell\t<ctx>\t<cmd>" with dedupe + tilde-relative cwd.
# ctx becomes "-" when cwd is empty (fish_history fallback path).
format_rows() {
  sort -n -u \
    | awk -F'\t' -v home="$HOME" '
        BEGIN { prev = "" }
        {
          ts = $1; cwd = $2; cmd = $3
          if (cmd == prev) next       # dedupe consecutive identicals
          prev = cmd
          # Shorten cwd: $HOME -> ~
          ctx = "-"
          if (cwd != "") {
            if (index(cwd, home) == 1) ctx = "~" substr(cwd, length(home) + 1)
            else                        ctx = cwd
          }
          # unix time -> HH:MM local
          datecmd = "date -r " ts " +%H:%M"
          datecmd | getline hhmm
          close(datecmd)
          printf "%s\tshell\t%s\t%s\n", hhmm, ctx, cmd
        }
      '
}

# ---------- Source 1: new cmdlog (has cwd) ----------
if [ -f "$CMDLOG" ]; then
  NEW_ROWS=$(awk -F'\t' \
      -v start="$DAY_START" -v end="$DAY_END" -v allowed_file="$ALLOWED_FILE" '
    BEGIN {
      while ((getline line < allowed_file) > 0) if (line != "") ok[line] = 1
      close(allowed_file)
    }
    {
      ts = $1 + 0
      cwd = $2
      cmd = $3
      if (ts < start || ts >= end) next
      if (cmd == "") next
      # first word of cmd
      first = cmd
      sub(/[[:space:]].*$/, "", first)
      if (!(first in ok)) next
      if (length(cmd) > 100) cmd = substr(cmd, 1, 97) "..."
      printf "%d\t%s\t%s\n", ts, cwd, cmd
    }
  ' "$CMDLOG")

  if [ -n "$NEW_ROWS" ]; then
    printf '%s\n' "$NEW_ROWS" | format_rows
    exit 0
  fi
fi

# ---------- Source 2: fish_history (legacy fallback, no cwd) ----------
[ -f "$HIST" ] || exit 0

# awk walks fish_history and extracts (when, cmd) pairs for matching dates & whitelist.
# Emits the same 3-column tuple as the new log, with cwd left empty.
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
    first = cmd
    sub(/[[:space:]].*$/, "", first)
    if (first in ok) {
      if (length(cmd) > 100) cmd = substr(cmd, 1, 97) "..."
      printf "%d\t\t%s\n", when, cmd
    }
  }
  cmd = ""
}
' "$HIST" \
  | format_rows
