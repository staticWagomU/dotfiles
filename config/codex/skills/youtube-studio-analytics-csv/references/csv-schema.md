# CSV Schema

Use this exact column order:

1. `チャンネル名`
2. `対象期間`
3. `動画タイトル`
4. `動画ID`
5. `公開日`
6. `再生回数`
7. `平均視聴時間`
8. `いいね数`
9. `コメント数`
10. `保存数`
11. `インプレッション数`

## Row construction

- `チャンネル名`: visible channel name in Studio, without forced suffix changes
- `対象期間`: `YYYY/MM/DD〜YYYY/MM/DD`
- `動画タイトル`: title shown in Studio
- `動画ID`: fill only when visible or reliably derivable from the current UI
- `公開日`: visible publish date
- metric columns: copy the visible UI values; use an empty string when unavailable

## Missing data rules

- No content in channel: create zero data rows
- No content in target period: create zero data rows
- Metric unavailable in accessible report: leave blank
- Do not write explanatory text into metric cells

## Example row

```json
{
  "動画タイトル": "サンプル動画",
  "動画ID": "abc123",
  "公開日": "2026/04/01",
  "再生回数": "120",
  "平均視聴時間": "1:42",
  "いいね数": "14",
  "コメント数": "2",
  "保存数": "",
  "インプレッション数": "340"
}
```
