#!/usr/bin/env swift
// events-from-calendar.swift - Emit Calendar events for a target date as TSV,
// with recurring events fully expanded into concrete instances.
//
// Output format (TSV): HH:MM\tcal\t<calendar_name>\t<title> (<duration>)
// Usage: swift events-from-calendar.swift [YYYY-MM-DD]   (defaults to yesterday)
//
// Why EventKit (not AppleScript):
//   Calendar.app's AppleScript interface compares recurring events by their
//   MASTER start date, not by expanded occurrences. A weekly "daily standup"
//   created on 2026-01-26 is invisible to a `whose start date ≥ 2026-04-10`
//   query, silently dropping most meetings from the daily timeline.
//   EKEventStore.predicateForEvents(...) + events(matching:) returns one
//   EKEvent per occurrence, with correct times and EXDATE/exception handling.
//
// TCC: first run triggers a Calendar access prompt for the parent terminal.

import EventKit
import Foundation

// ---- 1. Parse target date (default = yesterday, matching events-from-*.sh) ----
let argv = CommandLine.arguments
let dayFmt = DateFormatter()
dayFmt.dateFormat = "yyyy-MM-dd"
dayFmt.timeZone = .current

let targetString: String
if argv.count > 1 {
    targetString = argv[1]
} else {
    let y = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    targetString = dayFmt.string(from: y)
}

guard let target = dayFmt.date(from: targetString) else {
    FileHandle.standardError.write(Data("events-from-calendar: bad date '\(targetString)'\n".utf8))
    exit(1)
}

let cal = Calendar.current
let dayStart = cal.startOfDay(for: target)
guard let dayEnd = cal.date(byAdding: .day, value: 1, to: dayStart) else { exit(1) }

// ---- 2. Request calendar access synchronously (script context) ----
let store = EKEventStore()
let sem = DispatchSemaphore(value: 0)
var granted = false

if #available(macOS 14.0, *) {
    store.requestFullAccessToEvents { ok, _ in
        granted = ok
        sem.signal()
    }
} else {
    store.requestAccess(to: .event) { ok, _ in
        granted = ok
        sem.signal()
    }
}
sem.wait()

// Exit 0 on denial so the pipeline in events-build.sh treats this as "no events"
// rather than failing — matches the old AppleScript behaviour.
guard granted else { exit(0) }

// ---- 3. Query events for the target day (recurrences auto-expanded) ----
let predicate = store.predicateForEvents(withStart: dayStart, end: dayEnd, calendars: nil)
let events = store.events(matching: predicate)

// ---- 4. Format as TSV with dedup ----
let timeFmt = DateFormatter()
timeFmt.dateFormat = "HH:mm"
timeFmt.timeZone = .current

func sanitize(_ s: String) -> String {
    s.replacingOccurrences(of: "\t", with: " ")
     .replacingOccurrences(of: "\r", with: " ")
     .replacingOccurrences(of: "\n", with: " ")
}

func formatDuration(_ minutes: Int) -> String {
    if minutes >= 60 {
        return String(format: "%dh%02dm", minutes / 60, minutes % 60)
    }
    return "\(minutes)m"
}

// Dedup by (start_hhmm | title | duration): the same meeting surfaces once
// per calendar subscription (personal + work Gmail both invited).
var seen = Set<String>()

for ev in events {
    let startHHMM = timeFmt.string(from: ev.startDate)
    let durMin = max(0, Int(ev.endDate.timeIntervalSince(ev.startDate) / 60))
    let calName = sanitize(ev.calendar?.title ?? "unknown")
    let title = sanitize(ev.title ?? "(untitled)")

    let key = "\(startHHMM)|\(title)|\(durMin)"
    if !seen.insert(key).inserted { continue }

    print("\(startHHMM)\tcal\t\(calName)\t\(title) (\(formatDuration(durMin)))")
}
