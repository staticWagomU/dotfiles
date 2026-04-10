#!/usr/bin/env bash
# events-from-calendar.sh - Thin wrapper around events-from-calendar.swift.
#
# Output format (TSV): HH:MM\tcal\t<calendar_name>\t<title> (<duration>)
# Usage: events-from-calendar.sh [YYYY-MM-DD]   (defaults to yesterday)
#
# Why Swift (not AppleScript):
#   Calendar.app's AppleScript `whose start date` filter compares against the
#   MASTER start date of recurring events, silently dropping every daily /
#   weekly / monthly meeting whose series started outside the query range.
#   EventKit's predicateForEvents(...) expands recurrences into concrete
#   instances and handles EXDATE / modified occurrences correctly.
#
# The Swift source lives next to this file so both can be edited together.
# First invocation triggers a Calendar access TCC prompt for the parent
# terminal; grant it once to enable readout.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SWIFT_SRC="$SCRIPT_DIR/events-from-calendar.swift"

# Fail silently (empty output) if swift or the source file is missing —
# events-build.sh treats this as "no events" rather than aborting the build.
command -v swift >/dev/null 2>&1 || exit 0
[ -f "$SWIFT_SRC" ] || exit 0

exec swift "$SWIFT_SRC" "$@"
