#!/usr/bin/env bash
# events-from-retrace.sh - Emit focus sessions from Retrace.app DB as TSV.
#
# Output format (TSV): HH:MM\tretrace\t<app>\t<duration> (<start>-<end>)
#
# Strategy: group consecutive segments of the same bundleID (gap < 2 min)
# into a single "session". Emit only sessions with duration >= 10 min.
# This complements (not replaces) the existing ## スクリーン時間 section,
# which shows aggregates. Here we show time-ordered focus events.
#
# Data source notes (shared with events-diff.sh):
#   - Reads from Retrace.app's SQLite `segment` table.
#   - Retrace has a per-user *segment retention* setting in its Preferences.
#     This script only needs the TARGET date, but events-diff.sh walks back
#     8 same-weekdays (56 days) for its baseline comparison. If segment
#     retention is shorter than that, events-diff.sh degrades gracefully
#     (see its own header for thresholds).
#   - Current target retention: 90 days (set 2026-04-11). Default was far
#     shorter and left events-diff.sh silently empty.

set -uo pipefail

TARGET_DATE="${1:-$(date -v-1d '+%Y-%m-%d')}"
NEXT_DATE=$(date -j -v+1d -f '%Y-%m-%d' "$TARGET_DATE" '+%Y-%m-%d')

DB="$HOME/Library/Application Support/Retrace/retrace.db"
[ -f "$DB" ] || exit 0

DAY_START_MS=$(( $(date -j -f '%Y-%m-%d %H:%M:%S' "$TARGET_DATE 00:00:00" +%s) * 1000 ))
DAY_END_MS=$((   $(date -j -f '%Y-%m-%d %H:%M:%S' "$NEXT_DATE 00:00:00"   +%s) * 1000 ))

# Normalize bundle id to a short app name (matches retrace-summary.sh policy).
normalize_app() {
  case "$1" in
    com.microsoft.edgemac)          echo "Edge" ;;
    com.github.wez.wezterm)         echo "WezTerm" ;;
    com.tinyspeck.slackmacgap)      echo "Slack" ;;
    md.obsidian)                    echo "Obsidian" ;;
    com.anthropic.claudefordesktop) echo "Claude" ;;
    com.openai.codex)               echo "Codex" ;;
    com.microsoft.VSCode)           echo "VS Code" ;;
    com.apple.finder)               echo "Finder" ;;
    com.apple.logic10)              echo "Logic Pro" ;;
    com.naver.lineworks)            echo "LINE WORKS" ;;
    com.lambdalisue.Arto)           echo "Arto" ;;
    com.google.antigravity)         echo "Antigravity" ;;
    com.1password.1password)        echo "1Password" ;;
    pl.maketheweb.cleanshotx)       echo "CleanShot X" ;;
    com.tataeru.desktop-bible)      echo "Desktop Bible" ;;
    us.zoom.xos)                    echo "Zoom" ;;
    com.apple.Safari)               echo "Safari" ;;
    com.google.Chrome)              echo "Chrome" ;;
    fun.tw93.kaku)                  echo "Kaku" ;;
    notion.id)                      echo "Notion" ;;
    *)                              echo "${1##*.}" ;;
  esac
}

fmt_duration() {
  local min=$1
  if [ "$min" -ge 60 ]; then
    printf "%dh%02dm" $((min/60)) $((min%60))
  else
    printf "%dm" "$min"
  fi
}

# Pull raw segments; awk will group them into sessions.
sqlite3 -separator $'\t' "$DB" "
  SELECT bundleID, startDate, endDate
  FROM segment
  WHERE startDate < $DAY_END_MS AND endDate > $DAY_START_MS
  ORDER BY startDate;
" 2>/dev/null \
  | awk -F'\t' -v ds="$DAY_START_MS" -v de="$DAY_END_MS" -v gap_ms=300000 -v min_ms=600000 '
    function flush() {
      if (cur_bundle == "") return
      dur = cur_end - cur_start
      if (dur >= min_ms) printf "%d\t%d\t%s\n", cur_start, cur_end, cur_bundle
    }
    {
      # Clip to the day window
      s = ($2 < ds ? ds : $2)
      e = ($3 > de ? de : $3)
      if (e <= s) next

      if (cur_bundle == "" || $1 != cur_bundle || (s - cur_end) > gap_ms) {
        flush()
        cur_bundle = $1
        cur_start = s
        cur_end = e
      } else {
        if (e > cur_end) cur_end = e
      }
    }
    END { flush() }
  ' \
  | while IFS=$'\t' read -r start_ms end_ms bundle; do
      [ -z "$start_ms" ] && continue
      start_s=$(( start_ms / 1000 ))
      end_s=$((   end_ms   / 1000 ))
      dur_min=$(( (end_ms - start_ms) / 60000 ))
      app=$(normalize_app "$bundle")
      hhmm_start=$(date -r "$start_s" +%H:%M)
      hhmm_end=$(date   -r "$end_s"   +%H:%M)
      dur_str=$(fmt_duration "$dur_min")
      printf "%s\tretrace\t%s\t%s (%s–%s)\n" "$hhmm_start" "$app" "$dur_str" "$hhmm_start" "$hhmm_end"
    done
