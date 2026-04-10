#!/usr/bin/env bash
# events-from-calendar.sh - Emit Calendar.app events for a given date as TSV.
#
# Output format (TSV): HH:MM\tcal\t<calendar_name>\t<title> (<duration>)
# Sort: caller's responsibility.
#
# Source: macOS Calendar.app via osascript.
#   - Google Calendar, iCloud, and other calendars synced into Calendar.app
#     are all visible through this single interface.
#   - First invocation triggers a TCC permission prompt for the parent
#     terminal app (WezTerm / Terminal). Grant it once to enable readout.
#
# Why AppleScript (not icalBuddy or direct SQLite):
#   - icalBuddy is not in nixpkgs and would add a Homebrew dependency.
#   - Calendar.sqlitedb lives in a Group Container sandbox that refuses
#     direct reads in recent macOS versions.
#   - osascript has no install footprint and survives macOS upgrades.
#
# Usage: events-from-calendar.sh [YYYY-MM-DD]
#   defaults to yesterday

set -uo pipefail

TARGET_DATE="${1:-$(date -v-1d '+%Y-%m-%d')}"

# Build AppleScript date literals. Calendar.app uses local-time "date" objects.
# Format: "YYYY-MM-DD 00:00:00" is not directly parseable by AppleScript, so
# we construct date objects via `current date` and set components.
YEAR=$(echo "$TARGET_DATE"  | cut -d- -f1)
MONTH=$(echo "$TARGET_DATE" | cut -d- -f2)
DAY=$(echo "$TARGET_DATE"   | cut -d- -f3)

# AppleScript to enumerate events in the target day.
# Output (stdout): one line per event, fields separated by \x1f (unit separator)
# so that titles containing tabs or quotes don't corrupt the stream.
#   <start_hhmm> US <end_hhmm> US <duration_min> US <calendar_name> US <title>
# We convert to TSV in bash afterwards.
osa=$(cat <<OSASCRIPT
set _y to ${YEAR}
set _m to ${MONTH}
set _d to ${DAY}
set _dayStart to (current date)
set year of _dayStart to _y
set month of _dayStart to _m
set day of _dayStart to _d
set time of _dayStart to 0
set _dayEnd to _dayStart + (1 * days)
set AppleScript's text item delimiters to ""
set _out to ""
tell application "Calendar"
  repeat with _cal in calendars
    try
      set _events to (every event of _cal whose start date ≥ _dayStart and start date < _dayEnd)
      set _calName to name of _cal
      repeat with _ev in _events
        set _start to start date of _ev
        set _end to end date of _ev
        set _dur to ((_end - _start) / 60) as integer
        set _sh to (hours of _start) as string
        set _sm to (minutes of _start) as string
        if (count of _sh) < 2 then set _sh to "0" & _sh
        if (count of _sm) < 2 then set _sm to "0" & _sm
        set _eh to (hours of _end) as string
        set _em to (minutes of _end) as string
        if (count of _eh) < 2 then set _eh to "0" & _eh
        if (count of _em) < 2 then set _em to "0" & _em
        set _title to summary of _ev
        if _title is missing value then set _title to "(untitled)"
        set _line to (_sh & ":" & _sm) & (ASCII character 31) & (_eh & ":" & _em) & (ASCII character 31) & (_dur as string) & (ASCII character 31) & _calName & (ASCII character 31) & _title
        set _out to _out & _line & linefeed
      end repeat
    end try
  end repeat
end tell
return _out
OSASCRIPT
)

# Run and guard against silent failures.
raw=$(osascript -e "$osa" 2>/dev/null || true)

if [ -z "$raw" ]; then
  # Empty is valid (no events or missing permission). Do not fail the build.
  exit 0
fi

# Format duration: >=60min → "Hh MMm", else "Nm"
fmt_dur() {
  local m=$1
  if [ "$m" -ge 60 ]; then
    printf "%dh%02dm" $((m/60)) $((m%60))
  else
    printf "%dm" "$m"
  fi
}

# Parse the US-separated stream and emit TSV.
# Strip TABs/newlines from fields as a defensive measure (titles can contain anything).
# Dedup by (start_hhmm, title, duration): the same event often lives in multiple
# accounts (personal + work Gmail) and surfaces twice. The calendar name differs
# but the event is the same.
printf '%s\n' "$raw" \
  | awk -F$'\x1f' 'NF >= 5 {
      key = $1 "|" $5 "|" $3
      if (seen[key]++) next
      print
    }' \
  | while IFS=$'\x1f' read -r start_hhmm end_hhmm dur_min cal_name title; do
      [ -z "$start_hhmm" ] && continue
      cal_name=$(printf '%s' "$cal_name" | tr -d '\t\r\n')
      title=$(printf '%s' "$title" | tr -d '\t\r\n')
      dur_str=$(fmt_dur "${dur_min:-0}")
      printf "%s\tcal\t%s\t%s (%s)\n" "$start_hhmm" "$cal_name" "$title" "$dur_str"
    done
