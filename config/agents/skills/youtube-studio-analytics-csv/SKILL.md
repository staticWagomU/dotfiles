---
name: youtube-studio-analytics-csv
description: Collect analytics from YouTube Studio in Microsoft Edge and save them as a CSV with a fixed schema. Use when Codex is asked to open YouTube Studio, switch to a specific managed channel if needed, read the past 28 days of per-video metrics such as views, average view duration, likes, comments, saves, and impressions, and save the result as a CSV file.
---

# YouTube Studio Analytics CSV

## Overview

Use this skill to standardize a recurring YouTube Studio data collection task in Edge.
Read the target channel from the current Studio context or the user request, collect the requested metrics for the exact date range shown in the UI, and write a CSV with the fixed column order described in [references/csv-schema.md](references/csv-schema.md).

## Workflow

1. Confirm the target channel and current account context.
2. Open YouTube Studio in Microsoft Edge.
3. Switch channel only if the current Studio channel does not match the request.
4. Open Analytics and confirm the exact date range shown in the UI for `過去 28 日間`.
5. Collect per-video rows from detailed mode or the closest reliable UI surface.
6. Write the CSV with `scripts/write_youtube_analytics_csv.py`.
7. Report any gaps, such as unavailable metrics or channels with no content.

## Channel Handling

- Read the current channel name from the Studio header before switching.
- Open the account menu and use `アカウントを切り替える` only when the requested channel is not already selected.
- If the visible account list does not contain the requested channel, stop and tell the user what was visible.
- If a Google login or password step appears, hand control to the user instead of attempting credentials entry.

## Analytics Collection Rules

- Use Microsoft Edge unless the user explicitly asks for another browser.
- Use the exact absolute dates shown in the Studio UI. Do not infer them from the current date.
- Prefer `アナリティクス` -> `コンテンツ` -> `詳細モード` when the table exposes the needed per-video metrics.
- Collect these fields when available:
  - `再生回数`
  - `平均視聴時間`
  - `いいね数`
  - `コメント数`
  - `保存数`
  - `インプレッション数`
- If a metric is not exposed in the current report, leave that cell blank rather than inventing a value.
- If the channel has no videos or no rows for the requested period, create a header-only CSV and report that the UI showed no content or zero views.

## CSV Rules

- Default filename pattern: `youtube_<channel label>_YYYY年M月.csv`
- When the requested naming pattern includes `チャンネル`, append it only if the channel label does not already end with `チャンネル`.
- Keep the column order fixed as documented in [references/csv-schema.md](references/csv-schema.md).
- Use UTF-8 CSV.
- Preserve metric formatting when needed. For example, keep average view duration in the UI-friendly form instead of coercing it to seconds.

## Output Procedure

1. Build a JSON array of row objects matching the schema in [references/csv-schema.md](references/csv-schema.md).
2. Run:

```bash
python3 scripts/write_youtube_analytics_csv.py \
  --channel-name "輪ごむ" \
  --year 2026 \
  --month 4 \
  --period-start 2026-03-19 \
  --period-end 2026-04-15 \
  --rows-json /absolute/path/to/rows.json \
  --output-dir /absolute/path
```

3. For header-only output, either pass an empty JSON array or omit `--rows-json`.
4. Verify the file exists and briefly summarize whether rows were written or the file is header-only.

## Reliability Notes

- Treat Studio tables as the source of truth for this task, not memory.
- Use absolute dates in the final report, especially when the user said `過去28日間`.
- Do not claim that likes, comments, or saves were unavailable globally; report only that they were not visible in the current accessible UI path.
