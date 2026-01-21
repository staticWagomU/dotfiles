#!/bin/bash
# AI日誌用ユーティリティ関数集
# Source this file to use the functions

# タイムスタンプをJST時刻に変換 (HH:MM形式)
ts_to_jst() {
  local ts="$1"
  date -r "$ts" "+%H:%M" 2>/dev/null || echo "??:??"
}

# タイムスタンプをJST日時に変換 (YYYY-MM-DD HH:MM形式)
ts_to_jst_full() {
  local ts="$1"
  date -r "$ts" "+%Y-%m-%d %H:%M" 2>/dev/null || echo "????-??-?? ??:??"
}

# 最近N日間の日誌一覧を表示
list_recent_journals() {
  local days="${1:-7}"
  local journal_dir="$HOME/Documents/MyLife/ai-journals"

  if [ ! -d "$journal_dir" ]; then
    echo "日誌ディレクトリが存在しません: $journal_dir"
    return 1
  fi

  echo "=== 最近${days}日間のAI日誌 ==="
  find "$journal_dir" -name "*.md" -mtime -"$days" -type f | sort -r | while read -r file; do
    local filename=$(basename "$file" .md)
    local sessions=$(grep -c "^### セッション" "$file" 2>/dev/null)
    local projects=$(grep -c "^## プロジェクト:" "$file" 2>/dev/null)
    # 空の結果をハンドリング
    sessions=${sessions:-0}
    projects=${projects:-0}
    printf "%-12s  %d projects, %d sessions\n" "$filename" "${projects}" "${sessions}"
  done
}

# 指定日のログが存在するか確認
check_logs_exist() {
  local target_date="$1"
  local start_ts=$(date -j -f "%Y-%m-%d %H:%M:%S" "${target_date} 00:00:00" "+%s")000
  local end_ts=$(date -j -f "%Y-%m-%d %H:%M:%S" "${target_date} 23:59:59" "+%s")999

  local count=$(cat ~/.claude/history.jsonl | jq -c "select(.timestamp >= ${start_ts} and .timestamp <= ${end_ts})" | wc -l | tr -d ' ')

  if [ "$count" -eq 0 ]; then
    echo "false"
  else
    echo "true ($count entries)"
  fi
}

# 週間サマリーを生成するためのデータ抽出
extract_weekly_data() {
  local end_date="${1:-$(date +%Y-%m-%d)}"
  local start_date=$(date -j -v-6d -f "%Y-%m-%d" "$end_date" "+%Y-%m-%d")

  echo "=== 週間サマリー: $start_date ~ $end_date ==="

  local current_date="$start_date"
  while [[ "$current_date" != $(date -j -v+1d -f "%Y-%m-%d" "$end_date" "+%Y-%m-%d") ]]; do
    local start_ts=$(date -j -f "%Y-%m-%d %H:%M:%S" "${current_date} 00:00:00" "+%s")000
    local end_ts=$(date -j -f "%Y-%m-%d %H:%M:%S" "${current_date} 23:59:59" "+%s")999

    local count=$(cat ~/.claude/history.jsonl 2>/dev/null | jq -c "select(.timestamp >= ${start_ts} and .timestamp <= ${end_ts})" | wc -l | tr -d ' ')

    printf "%s: %3d entries\n" "$current_date" "$count"

    current_date=$(date -j -v+1d -f "%Y-%m-%d" "$current_date" "+%Y-%m-%d")
  done
}

# プロジェクト別の活動統計
project_stats() {
  local days="${1:-30}"
  local cutoff_ts=$(date -v-${days}d "+%s")000

  echo "=== 過去${days}日間のプロジェクト別統計 ==="

  cat ~/.claude/history.jsonl | \
    jq -c "select(.timestamp >= ${cutoff_ts})" | \
    jq -rs 'group_by(.project) | map({
      project: (.[0].project | split("/") | last),
      entries: length,
      sessions: ([.[].sessionId] | unique | length)
    }) | sort_by(-.entries) | .[]' | \
    jq -r '"\(.project)\t\(.entries) entries\t\(.sessions) sessions"' | \
    column -t -s $'\t'
}

# 使用方法を表示
journal_help() {
  cat << 'EOF'
AI日誌ユーティリティ関数:

  ts_to_jst <timestamp>        - タイムスタンプをHH:MM形式に変換
  ts_to_jst_full <timestamp>   - タイムスタンプをYYYY-MM-DD HH:MM形式に変換
  list_recent_journals [days]  - 最近N日間の日誌一覧 (デフォルト: 7日)
  check_logs_exist <date>      - 指定日のログ存在確認
  extract_weekly_data [date]   - 週間サマリーデータ抽出
  project_stats [days]         - プロジェクト別統計 (デフォルト: 30日)
  journal_help                 - このヘルプを表示

使用例:
  source ~/.claude/scripts/journal-utils.sh
  list_recent_journals 14
  project_stats 7
EOF
}
