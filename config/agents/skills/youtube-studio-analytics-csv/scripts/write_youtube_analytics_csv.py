#!/usr/bin/env python3

from __future__ import annotations

import argparse
import csv
import json
from pathlib import Path


COLUMNS = [
    "チャンネル名",
    "対象期間",
    "動画タイトル",
    "動画ID",
    "公開日",
    "再生回数",
    "平均視聴時間",
    "いいね数",
    "コメント数",
    "保存数",
    "インプレッション数",
]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Write a YouTube Studio analytics CSV with a fixed schema."
    )
    parser.add_argument("--channel-name", required=True, help="Studio channel name.")
    parser.add_argument("--year", required=True, type=int, help="Year for output filename.")
    parser.add_argument("--month", required=True, type=int, help="Month for output filename.")
    parser.add_argument("--period-start", required=True, help="Start date shown in UI.")
    parser.add_argument("--period-end", required=True, help="End date shown in UI.")
    parser.add_argument(
        "--rows-json",
        help="Path to a JSON file containing an array of row objects. "
        "If omitted, create a header-only CSV.",
    )
    parser.add_argument("--output-dir", required=True, help="Directory for the CSV file.")
    parser.add_argument(
        "--channel-suffix",
        default="チャンネル",
        help="Suffix appended to filename label when absent. Default: チャンネル",
    )
    return parser.parse_args()


def build_filename_label(channel_name: str, suffix: str) -> str:
    label = channel_name.strip()
    if suffix and not label.endswith(suffix):
        label = f"{label}{suffix}"
    return "".join("_" if c in '/\\:*?\"<>|' else c for c in label)


def load_rows(rows_json: str | None) -> list[dict]:
    if not rows_json:
        return []
    data = json.loads(Path(rows_json).read_text(encoding="utf-8"))
    if not isinstance(data, list):
        raise ValueError("rows JSON must be an array")
    normalized = []
    for row in data:
        if not isinstance(row, dict):
            raise ValueError("each row must be an object")
        normalized.append(row)
    return normalized


def main() -> int:
    args = parse_args()
    rows = load_rows(args.rows_json)
    period = f"{args.period_start}〜{args.period_end}"
    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    filename_label = build_filename_label(args.channel_name, args.channel_suffix)
    filename = f"youtube_{filename_label}_{args.year}年{args.month}月.csv"
    output_path = output_dir / filename

    with output_path.open("w", encoding="utf-8", newline="") as fh:
        writer = csv.DictWriter(fh, fieldnames=COLUMNS)
        writer.writeheader()
        for row in rows:
            writer.writerow(
                {
                    "チャンネル名": args.channel_name,
                    "対象期間": period,
                    "動画タイトル": row.get("動画タイトル", ""),
                    "動画ID": row.get("動画ID", ""),
                    "公開日": row.get("公開日", ""),
                    "再生回数": row.get("再生回数", ""),
                    "平均視聴時間": row.get("平均視聴時間", ""),
                    "いいね数": row.get("いいね数", ""),
                    "コメント数": row.get("コメント数", ""),
                    "保存数": row.get("保存数", ""),
                    "インプレッション数": row.get("インプレッション数", ""),
                }
            )

    print(output_path)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
