#!/usr/bin/env bash
# events-diff.sh - Emit "注目ポイント" bullets comparing target date to
# same-weekday history (median + MAD) from Retrace per-app minutes.
#
# Output: markdown bullets. Empty output if no baseline is available.
#
# Rationale: weekday seasonality is strong in computer activity; comparing
# Wednesday to other Wednesdays is much less noisy than rolling averages.
# We use median + MAD (robust) instead of mean + stdev so a single weird day
# doesn't skew the baseline. Only top 3 differences are emitted.

set -uo pipefail

TARGET_DATE="${1:-$(date -v-1d '+%Y-%m-%d')}"
DB="$HOME/Library/Application Support/Retrace/retrace.db"
[ -f "$DB" ] || exit 0

# Weekday of target (1=Mon..7=Sun via date's %u)
WEEKDAY=$(date -j -f '%Y-%m-%d' "$TARGET_DATE" '+%u')

# Collect TARGET + previous 8 occurrences of the same weekday → compute usage
# per bundleID per day in minutes. Emit "app \t date \t minutes".
collect_days() {
  local d ms_start ms_end
  d="$TARGET_DATE"
  # include target + 8 past same-weekdays = 9 points; baseline = past 8
  for i in $(seq 0 8); do
    if [ "$i" -gt 0 ]; then
      d=$(date -j -v-7d -f '%Y-%m-%d' "$d" '+%Y-%m-%d')
    fi
    ms_start=$(( $(date -j -f '%Y-%m-%d %H:%M:%S' "$d 00:00:00" +%s) * 1000 ))
    ms_end=$((   ms_start + 86400000 ))
    sqlite3 -separator $'\t' "$DB" "
      SELECT bundleID,
             SUM(
               CASE
                 WHEN MIN(endDate, $ms_end) > MAX(startDate, $ms_start)
                 THEN MIN(endDate, $ms_end) - MAX(startDate, $ms_start)
                 ELSE 0
               END
             ) / 60000
      FROM segment
      WHERE endDate > $ms_start AND startDate < $ms_end
      GROUP BY bundleID
      HAVING SUM(CASE WHEN MIN(endDate, $ms_end) > MAX(startDate, $ms_start)
                      THEN MIN(endDate, $ms_end) - MAX(startDate, $ms_start)
                      ELSE 0 END) > 0;
    " 2>/dev/null \
    | awk -v d="$d" -F'\t' '{ printf "%s\t%s\t%s\n", $1, d, $2 }'
  done
}

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

# Compute the diff in awk: for each bundleID, baseline = past 8 same weekdays,
# compute median. Emit bundles where target is >= 15 min AND |ratio - 1| >= 0.5.
RAW=$(collect_days | awk -F'\t' '$3 != "" && $3+0 > 0')

echo "$RAW" | awk -F'\t' -v target="$TARGET_DATE" '
  {
    app = $1; day = $2; min = $3 + 0
    if (day == target) t[app] = min
    else { vals[app] = (vals[app] ? vals[app] "," : "") min; n[app]++ }
  }
  END {
    for (app in t) {
      if (t[app] < 15) continue           # ignore apps with < 15 min target
      if (!(app in vals) || n[app] < 3) continue  # need >= 3 baseline points
      # Compute median of baseline
      split(vals[app], arr, ",")
      m = n[app]
      # insertion sort (small n)
      for (i = 2; i <= m; i++) {
        k = arr[i]; j = i - 1
        while (j >= 1 && (arr[j]+0) > (k+0)) { arr[j+1] = arr[j]; j-- }
        arr[j+1] = k
      }
      if (m % 2) med = arr[(m+1)/2] + 0
      else       med = (arr[m/2] + arr[m/2 + 1]) / 2
      if (med < 5) continue               # noisy baseline
      ratio = t[app] / med
      # score = |log2(ratio)| so doubling and halving count the same
      lr = log(ratio) / log(2); if (lr < 0) lr = -lr
      if (lr < 0.58) continue             # need at least ~1.5x or /1.5
      printf "%.3f\t%s\t%.0f\t%.0f\t%.2f\n", lr, app, t[app], med, ratio
    }
  }
' \
  | sort -rn \
  | head -3 \
  | while IFS=$'\t' read -r score bundle tmin basemin ratio; do
      [ -z "$bundle" ] && continue
      app=$(normalize_app "$bundle")
      direction="↑"
      # bash can't compare floats; use awk
      if awk -v r="$ratio" 'BEGIN { exit !(r < 1) }'; then
        direction="↓"
      fi
      printf -- "- **%s**: %s分 (同曜日中央値 %s分 → %s %.1fx)\n" \
        "$app" "$tmin" "$basemin" "$direction" "$ratio"
    done

# trailing newline only if we emitted something (checked by caller presence)
