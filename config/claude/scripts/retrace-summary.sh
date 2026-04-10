#!/usr/bin/env bash
# retrace-summary.sh - 機械的な客観日報ジェネレーター
#
# 目的:
#   Retrace (macOSのスクリーン時間記録アプリ) のSQLite DBから
#   「PC上で自分が何をしていたか」を機械的に記録する客観日報を生成する。
#   人間が書く感情込みの日記を補完する客観記録として使う。
#
# Usage: ./retrace-summary.sh [--markdown] [YYYY-MM-DD]
#   --markdown: Markdown形式で出力 (ファイル保存向け)
#   デフォルト : ターミナル表示 (ANSIカラー + バーグラフ)

DB="$HOME/Library/Application Support/Retrace/retrace.db"

# ===============================================================
# 引数パース / 日付境界
# ===============================================================
FORMAT="terminal"
TARGET_DATE=""
for arg in "$@"; do
  case "$arg" in
    --markdown) FORMAT="markdown" ;;
    *)          TARGET_DATE="$arg" ;;
  esac
done
TARGET_DATE="${TARGET_DATE:-$(date -v-1d '+%Y-%m-%d')}"

if [ ! -f "$DB" ]; then
  echo "Retrace DB not found: $DB"
  exit 1
fi

DAY_START_S=$(date -j -f '%Y-%m-%d %H:%M:%S' "$TARGET_DATE 00:00:00" +%s)
DAY_END_S=$((DAY_START_S + 86400))
DAY_START_MS=$((DAY_START_S * 1000))
DAY_END_MS=$((DAY_END_S * 1000))

# ===============================================================
# アプリ名の短縮
# ===============================================================
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
    com.google.antigravity)         echo "Google" ;;
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

# ===============================================================
# ANSI colors
# ===============================================================
if [ "$FORMAT" = "terminal" ]; then
  B=$'\033[1m';   R=$'\033[0m'
  C=$'\033[36m';  Y=$'\033[33m'
  G=$'\033[32m';  W=$'\033[37m'
  D=$'\033[90m';  RED=$'\033[31m'
  MAGENTA=$'\033[35m'; BLUE=$'\033[34m'
else
  B=""; R=""; C=""; Y=""; G=""; W=""; D=""; RED=""; MAGENTA=""; BLUE=""
fi
COLS=$(tput cols 2>/dev/null || echo 80)
hr()     { printf '%*s\n' "$COLS" '' | tr ' ' '─'; }
center() {
  local text="$1" len=${#text}
  printf '%*s%s\n' $(( (COLS - len) / 2 )) '' "$text"
}
make_bar() {
  local minutes=$1 max_minutes=$2
  local bar_max=$(( COLS - 6 ))
  local bar_len=0
  if [ "$max_minutes" -gt 0 ]; then
    bar_len=$(( minutes * bar_max / max_minutes ))
  fi
  [ "$bar_len" -lt 1 ] && bar_len=1
  printf '%*s' "$bar_len" '' | tr ' ' '▓'
}

# ===============================================================
# bash 側のタイトルクリーニング
# SQL側で基本的なサフィックス除去は済ませているので、
# ここでは WezTerm/Claude Code/Obsidian/Zoom の特殊処理のみ
# ===============================================================
clean_title() {
  local title="$1"

  # Obsidian バージョン文字列はノイズ
  [[ "$title" == *"Obsidian "[0-9]* ]] && return

  # [N/N] claude ... path → project名 (Claude Code)
  if [[ "$title" =~ ^\[[0-9]+/[0-9]+\]\ claude(-mode\ subscrip)?\  ]]; then
    local last_arg="${title##* }"
    if [ "$last_arg" = "~" ] || [ "$last_arg" = "" ]; then
      echo "Claude Code"
    else
      echo "$(basename "$last_arg") (Claude Code)"
    fi
    return
  fi

  # WezTerm 汎用: [N/N] cmd ~/path/project → "cmd (project)"
  if [[ "$title" =~ ^\[[0-9]+/[0-9]+\]\ (.+)$ ]]; then
    local rest="${BASH_REMATCH[1]}"
    # 末尾が ~/... path パターンか
    if [[ "$rest" =~ ^(.*)[[:space:]](~[^[:space:]]*)$ ]]; then
      local cmd="${BASH_REMATCH[1]}"
      local path="${BASH_REMATCH[2]}"
      local proj
      proj=$(basename "$path")
      if [ -n "$proj" ] && [ "$proj" != "~" ]; then
        if [ -z "$cmd" ] || [ "$cmd" = "fish" ]; then
          echo "$proj"
        else
          echo "${cmd} (${proj})"
        fi
        return
      fi
    fi
    echo "$rest"
    return
  fi

  # "title - Zoom" (SQL側では Zoom は落としていない)
  local zoom_cleaned="${title% - Zoom*}"
  if [ "$zoom_cleaned" != "$title" ]; then
    echo "${zoom_cleaned} (Zoom)"
    return
  fi

  echo "$title"
}

# ===============================================================
# SQL フラグメント: タイトル正規化 (ノイズ除去)
# ===============================================================
# 表示用 title 列を生成するSQL式。raw_win(未加工)はLIKE分類に使う。
# 🔊 / 休止中 / ブラウザ/Slack/Google Workspace サフィックスを除去。
SQL_CLEAN=$(cat <<'SQL'
TRIM(
  REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(windowName,
    '🔊', ''),
    ' - Microsoft Edge - 個人', ''),
    ' - Microsoft Edge', ''),
    ' - Google Chrome', ''),
    ' - Slack', ''),
    ' - Google ドキュメント', ''),
    ' - Google スプレッドシート', ''),
    ' - Google スライド', ''),
    ' - Google Docs', ''),
    ' - Google Sheets', ''),
    ' - Google Slides', ''),
    ' - 休止中', ''),
    ' - オーディオを再生中', '')
)
SQL
)

# ===============================================================
# SQL ヘルパー: オーバーラップCTEで2時間ブロックを按分
# ===============================================================
# blocks: hr ∈ {0,2,...,22}, bstart/bend は ms 単位
# overlaps 列: hr, bundleID, raw_win, title, dur_ms
# セグメントがブロック境界を跨ぐ場合も正確に按分 (codex案⑤)
run_block_sql() {
  local rest="$1"
  sqlite3 "$DB" "
    WITH RECURSIVE
    blocks(hr, bstart, bend) AS (
      SELECT 0, $DAY_START_MS, $DAY_START_MS + 7200000
      UNION ALL
      SELECT hr+2, bend, bend+7200000 FROM blocks WHERE hr < 22
    ),
    overlaps AS (
      SELECT
        b.hr,
        s.bundleID,
        s.windowName AS raw_win,
        $SQL_CLEAN AS title,
        CASE
          WHEN MIN(s.endDate, b.bend) > MAX(s.startDate, b.bstart)
          THEN MIN(s.endDate, b.bend) - MAX(s.startDate, b.bstart)
          ELSE 0
        END AS dur_ms
      FROM blocks b
      JOIN segment s
        ON s.endDate > b.bstart AND s.startDate < b.bend
      WHERE s.endDate > s.startDate
    )
    $rest
  " 2>/dev/null
}

# ===============================================================
# ブロック別タイトル取得ヘルパー
# ===============================================================

# ウィンドウタイトル (YouTube/Meet/GWS 除外、2min以上、最大3件)
get_window_titles() {
  local hr=$1
  run_block_sql "
    , w AS (
      SELECT title, SUM(dur_ms) AS d
      FROM overlaps
      WHERE hr = $hr
        AND raw_win IS NOT NULL AND raw_win != ''
        AND raw_win NOT LIKE '%YouTube%'
        AND raw_win NOT LIKE '%meet.google.com%'
        AND raw_win NOT LIKE '%Google Meet%'
        AND raw_win NOT LIKE '% - Google Docs%'
        AND raw_win NOT LIKE '% - Google Sheets%'
        AND raw_win NOT LIKE '% - Google Slides%'
        AND raw_win NOT LIKE '% - Google ドキュメント%'
        AND raw_win NOT LIKE '% - Google スプレッドシート%'
        AND raw_win NOT LIKE '% - Google スライド%'
      GROUP BY title
      HAVING d >= 120000
    )
    SELECT SUBSTR(title, 1, 70) FROM w ORDER BY d DESC LIMIT 3;
  "
}

# YouTubeタイトル (最大2件)
get_youtube_titles() {
  local hr=$1
  run_block_sql "
    , w AS (
      SELECT title, SUM(dur_ms) AS d
      FROM overlaps
      WHERE hr = $hr AND raw_win LIKE '%YouTube%'
      GROUP BY title
      HAVING d >= 60000
    )
    SELECT SUBSTR(title, 1, 65) FROM w ORDER BY d DESC LIMIT 2;
  "
}

# Google Workspace タイトル (Docs/Sheets/Slides、時間不問、最大3件)
get_gworkspace_titles() {
  local hr=$1
  run_block_sql "
    SELECT DISTINCT SUBSTR(title, 1, 60)
    FROM overlaps
    WHERE hr = $hr
      AND title IS NOT NULL AND title != ''
      AND title != 'Google ドキュメント'
      AND title != 'Google スプレッドシート'
      AND title != 'Google スライド'
      AND (raw_win LIKE '% - Google Docs%'
        OR raw_win LIKE '% - Google Sheets%'
        OR raw_win LIKE '% - Google Slides%'
        OR raw_win LIKE '% - Google ドキュメント%'
        OR raw_win LIKE '% - Google スプレッドシート%'
        OR raw_win LIKE '% - Google スライド%')
    LIMIT 3;
  "
}

# Meet 回数 (ブロック内のユニーク会議数)
get_meet_count() {
  local hr=$1
  run_block_sql "
    SELECT COUNT(DISTINCT meet_key) FROM (
      SELECT
        CASE
          WHEN raw_win LIKE '%meet.google.com/landing%' THEN NULL
          WHEN raw_win LIKE '%meet.google.com/%'
            THEN SUBSTR(raw_win, INSTR(raw_win, 'meet.google.com/'), 27)
          WHEN raw_win LIKE '%Google Meet%'
            THEN 'Google Meet'
          ELSE NULL
        END AS meet_key
      FROM overlaps
      WHERE hr = $hr
        AND (raw_win LIKE '%meet.google.com%' OR raw_win LIKE '%Google Meet%')
    ) t
    WHERE meet_key IS NOT NULL;
  " | head -1
}

# ===============================================================
# 日次集計 (ハイライトセクション用)
# ===============================================================

# 触った Google Docs ファイル (最大5件)
get_day_docs() {
  run_block_sql "
    SELECT DISTINCT SUBSTR(title, 1, 50) FROM overlaps
    WHERE title IS NOT NULL AND title != ''
      AND title != 'Google ドキュメント' AND title != 'Google Docs'
      AND (raw_win LIKE '% - Google Docs%' OR raw_win LIKE '% - Google ドキュメント%')
    LIMIT 5;
  "
}

get_day_sheets() {
  run_block_sql "
    SELECT DISTINCT SUBSTR(title, 1, 50) FROM overlaps
    WHERE title IS NOT NULL AND title != ''
      AND title != 'Google スプレッドシート' AND title != 'Google Sheets'
      AND (raw_win LIKE '% - Google Sheets%' OR raw_win LIKE '% - Google スプレッドシート%')
    LIMIT 5;
  "
}

get_day_slides() {
  run_block_sql "
    SELECT DISTINCT SUBSTR(title, 1, 50) FROM overlaps
    WHERE title IS NOT NULL AND title != ''
      AND title != 'Google スライド' AND title != 'Google Slides'
      AND (raw_win LIKE '% - Google Slides%' OR raw_win LIKE '% - Google スライド%')
    LIMIT 5;
  "
}

# 日次 Meet 総回数
get_day_meet_count() {
  run_block_sql "
    SELECT COUNT(DISTINCT meet_key) FROM (
      SELECT
        CASE
          WHEN raw_win LIKE '%meet.google.com/landing%' THEN NULL
          WHEN raw_win LIKE '%meet.google.com/%'
            THEN SUBSTR(raw_win, INSTR(raw_win, 'meet.google.com/'), 27)
          WHEN raw_win LIKE '%Google Meet%'
            THEN 'Google Meet'
          ELSE NULL
        END AS meet_key
      FROM overlaps
      WHERE raw_win LIKE '%meet.google.com%' OR raw_win LIKE '%Google Meet%'
    ) t
    WHERE meet_key IS NOT NULL;
  " | head -1
}

# 開発プロジェクト (WezTerm/VS Code のタイトルから path basename 抽出)
get_day_dev_projects() {
  sqlite3 "$DB" "
    SELECT windowName FROM segment
    WHERE startDate < $DAY_END_MS AND endDate > $DAY_START_MS
      AND bundleID IN ('com.github.wez.wezterm', 'com.microsoft.VSCode')
      AND windowName IS NOT NULL AND windowName != '';
  " 2>/dev/null | awk '
    {
      line = $0
      sub(/^\[[0-9]+\/[0-9]+\] */, "", line)
      # 末尾の ~/... パス を検出 (空白区切り最終token)
      n = split(line, toks, " ")
      last = toks[n]
      if (last ~ /^~/) {
        m = split(last, segs, "/")
        if (m > 0 && segs[m] != "" && segs[m] != "~") {
          count[segs[m]]++
        }
      }
    }
    END {
      for (p in count) printf "%s|%d\n", p, count[p]
    }
  ' | sort -t'|' -k2 -nr | head -6
}

# GitHub 参照 (owner/repo または owner/repo#N) を Edge タイトルから抽出
# 前提: GitHub タブタイトルの典型パターン
#   "file/path at SHA · owner/repo"
#   "title by user · Pull Request #N · owner/repo"
#   "Release X · owner/repo"
# いずれも ` · owner/repo` が末尾に来る
get_day_github_refs() {
  sqlite3 "$DB" "
    SELECT DISTINCT windowName FROM segment
    WHERE startDate < $DAY_END_MS AND endDate > $DAY_START_MS
      AND bundleID = 'com.microsoft.edgemac'
      AND windowName IS NOT NULL
      AND (windowName LIKE '% · %/%' OR windowName LIKE '%Pull Request #%' OR windowName LIKE '%Issue #%');
  " 2>/dev/null | while IFS= read -r line; do
    # 末尾ノイズ除去
    line="${line% - Microsoft Edge - 個人}"
    line="${line% - Microsoft Edge}"
    line="${line% 🔊}"
    line="${line%🔊}"
    # パターン1: PR #N · owner/repo
    if [[ "$line" =~ Pull\ Request\ \#([0-9]+).*·\ ([A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+)[[:space:]]*$ ]]; then
      echo "${BASH_REMATCH[2]}#${BASH_REMATCH[1]}"
      continue
    fi
    # パターン2: Issue #N · owner/repo
    if [[ "$line" =~ Issue\ \#([0-9]+).*·\ ([A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+)[[:space:]]*$ ]]; then
      echo "${BASH_REMATCH[2]}#${BASH_REMATCH[1]}"
      continue
    fi
    # パターン3: ... · owner/repo (末尾)
    if [[ "$line" =~ ·\ ([A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+)[[:space:]]*$ ]]; then
      repo="${BASH_REMATCH[1]}"
      # owner と repo がそれぞれ 2文字以上
      if [[ "$repo" =~ ^[A-Za-z0-9_.-]{2,}/[A-Za-z0-9_.-]{2,}$ ]]; then
        echo "$repo"
      fi
    fi
  done | sort -u | head -8
}

# ===============================================================
# タイムライン分析 (集中セッション / 散漫度 / 最長休憩)
# ===============================================================

# 指定日のセグメントを時系列 TSV で出力: start_s \t end_s \t bundleID \t raw_win
dump_timeline() {
  sqlite3 -separator $'\t' "$DB" "
    SELECT
      startDate/1000 AS s,
      endDate/1000 AS e,
      bundleID,
      COALESCE(windowName, '')
    FROM segment
    WHERE startDate < $DAY_END_MS AND endDate > $DAY_START_MS
      AND endDate > startDate
    ORDER BY startDate;
  " 2>/dev/null
}

# 集中セッション検出
# 条件:
#   - YouTube除外
#   - 5分以上のギャップでセッション区切り
#   - 合計 >= 25分
#   - 主要アプリ占有率 >= 60% (アプリ切替の絶対数より「ひとつの作業に集中していたか」を見る)
# NOTE: BSD awk は strftime 非対応のため、DAY_START_S 基準で HH:MM を手計算
detect_focus_sessions() {
  dump_timeline | awk -F'\t' -v day_start="$DAY_START_S" '
    function fmt(t,    secs, hh, mm) {
      secs = t - day_start
      if (secs < 0) secs = 0
      hh = int(secs / 3600) % 24
      mm = int(secs / 60) % 60
      return sprintf("%02d:%02d", hh, mm)
    }
    function flush(    top_app, top_sec, a, frac) {
      if (active_sec >= 1500 && start0 > 0) {
        top_app = ""
        top_sec = 0
        for (a in byapp) {
          if (byapp[a] > top_sec) { top_sec = byapp[a]; top_app = a }
        }
        frac = (active_sec > 0) ? top_sec / active_sec : 0
        if (frac >= 0.6) {
          printf "%s\t%s\t%d\t%d\t%s\n",
            fmt(start0), fmt(end1), int(active_sec/60), int(frac*100), top_app
        }
      }
      active_sec = 0
      delete byapp
      start0 = 0; end1 = 0
    }
    BEGIN { active_sec=0; start0=0; end1=0 }
    {
      s = $1; e = $2; app = $3; title = $4
      dur = e - s
      if (dur <= 0) next
      if (title ~ /YouTube/) next
      if (end1 > 0 && s - end1 >= 300) flush()
      if (start0 == 0) start0 = s
      active_sec += dur
      byapp[app] += dur
      end1 = e
    }
    END { flush() }
  '
}

# 散漫度 (アプリ切替/稼働時間) と最長非稼働ギャップ
calc_distraction_and_break() {
  dump_timeline | awk -F'\t' -v day_start="$DAY_START_S" '
    function fmt(t,    secs, hh, mm) {
      secs = t - day_start
      if (secs < 0) secs = 0
      hh = int(secs / 3600) % 24
      mm = int(secs / 60) % 60
      return sprintf("%02d:%02d", hh, mm)
    }
    BEGIN { active=0; switches=0; maxgap=0; gap_s=0; gap_e=0; prev_end=0; prev_app="" }
    {
      s = $1; e = $2; app = $3
      dur = e - s
      if (dur <= 0) next
      active += dur
      if (prev_end > 0) {
        gap = s - prev_end
        # 1〜180分のギャップを「休憩候補」とする
        # (3時間超は睡眠/AFKと見なし除外、60秒未満はノイズ)
        if (gap >= 60 && gap <= 10800 && gap > maxgap) {
          maxgap = gap; gap_s = prev_end; gap_e = s
        }
      }
      if (prev_app != "" && app != prev_app) switches++
      prev_app = app
      prev_end = e
    }
    END {
      rate = (active > 0) ? switches / (active/3600.0) : 0
      printf "switches=%d\n", switches
      printf "switches_per_hour=%.1f\n", rate
      printf "longest_break_min=%d\n", int(maxgap/60)
      if (maxgap > 0) {
        printf "longest_break_at=%s-%s\n", fmt(gap_s), fmt(gap_e)
      } else {
        printf "longest_break_at=-\n"
      }
    }
  '
}

# ===============================================================
# データ収集 (TOTAL, BLOCK_TOTAL_MIN, BLOCK_YT_MIN, BLOCK_APPS)
# ===============================================================
# 全てのブロック単位集計は overlap CTE を使うことで、ブロック境界を
# 跨ぐセグメントの按分を正しく行う (codex案⑤)
# ---------------------------------------------------------------

TOTAL=$(sqlite3 "$DB" "
  SELECT COALESCE(ROUND(SUM(
    CASE WHEN MIN(endDate, $DAY_END_MS) > MAX(startDate, $DAY_START_MS)
         THEN MIN(endDate, $DAY_END_MS) - MAX(startDate, $DAY_START_MS)
         ELSE 0 END
  )/1000.0/60.0/60.0, 1), 0)
  FROM segment
  WHERE startDate < $DAY_END_MS AND endDate > $DAY_START_MS;
" 2>/dev/null)
TOTAL=${TOTAL:-0}

if [ "$TOTAL" = "0" ] || [ "$TOTAL" = "0.0" ]; then
  echo "No data for $TARGET_DATE"
  exit 0
fi

TOTAL_YT=$(sqlite3 "$DB" "
  SELECT COALESCE(ROUND(SUM(
    CASE WHEN MIN(endDate, $DAY_END_MS) > MAX(startDate, $DAY_START_MS)
         THEN MIN(endDate, $DAY_END_MS) - MAX(startDate, $DAY_START_MS)
         ELSE 0 END
  )/1000.0/60.0/60.0, 1), 0)
  FROM segment
  WHERE startDate < $DAY_END_MS AND endDate > $DAY_START_MS
    AND windowName LIKE '%YouTube%';
" 2>/dev/null)
TOTAL_YT=${TOTAL_YT:-0}

declare -A BLOCK_TOTAL_MIN
declare -A BLOCK_YT_MIN
declare -A BLOCK_APPS

# 2時間ブロックの合計分 / YouTube分
while IFS='|' read -r hr total_min yt_min; do
  [ -z "$hr" ] && continue
  BLOCK_TOTAL_MIN[$hr]="$total_min"
  BLOCK_YT_MIN[$hr]="${yt_min:-0}"
done < <(run_block_sql "
  SELECT hr,
    ROUND(SUM(dur_ms)/1000.0/60.0, 0),
    ROUND(SUM(CASE WHEN raw_win LIKE '%YouTube%' THEN dur_ms ELSE 0 END)/1000.0/60.0, 0)
  FROM overlaps
  GROUP BY hr;
")

MAX_BLOCK_MIN=0
for v in "${BLOCK_TOTAL_MIN[@]}"; do
  val=${v%.*}
  [ "${val:-0}" -gt "$MAX_BLOCK_MIN" ] && MAX_BLOCK_MIN=$val
done

# ブロック x アプリ (上位4アプリのみ)
while IFS='|' read -r hr bundleID minutes; do
  [ -z "$hr" ] && continue
  app_name=$(normalize_app "$bundleID")
  cur="${BLOCK_APPS[$hr]:-}"
  cnt=0
  if [ -n "$cur" ]; then
    cnt=$(echo "$cur" | tr ',' '\n' | grep -c '[^ ]' 2>/dev/null || echo 0)
  fi
  if [ "$cnt" -lt 4 ]; then
    if [ -n "$cur" ]; then
      BLOCK_APPS[$hr]="$cur, ${app_name}(${minutes}m)"
    else
      BLOCK_APPS[$hr]="${app_name}(${minutes}m)"
    fi
  fi
done < <(run_block_sql "
  SELECT hr, bundleID, ROUND(SUM(dur_ms)/1000.0/60.0, 0) AS m
  FROM overlaps
  WHERE bundleID IS NOT NULL
  GROUP BY hr, bundleID
  HAVING m >= 1
  ORDER BY hr, m DESC;
")

# 最初/最後の活動ブロック (この範囲外の非稼働ブロックは出力しない)
FIRST_ACTIVE=99
LAST_ACTIVE=-1
for hr in 0 2 4 6 8 10 12 14 16 18 20 22; do
  tm=${BLOCK_TOTAL_MIN[$hr]:-0}
  tm_int=${tm%.*}
  if [ "${tm_int:-0}" -ge 1 ]; then
    [ "$hr" -lt "$FIRST_ACTIVE" ] && FIRST_ACTIVE=$hr
    [ "$hr" -gt "$LAST_ACTIVE" ] && LAST_ACTIVE=$hr
  fi
done

# ===============================================================
# Markdown 出力
# ===============================================================
output_markdown() {
  local FILE_DATE
  FILE_DATE=$(echo "$TARGET_DATE" | tr '-' '_')

  # 散漫度 / 最長休憩
  local DIST switches sph lbm lba
  DIST=$(calc_distraction_and_break)
  switches=$(echo "$DIST" | awk -F= '/^switches=/{print $2}')
  sph=$(echo "$DIST"      | awk -F= '/^switches_per_hour=/{print $2}')
  lbm=$(echo "$DIST"      | awk -F= '/^longest_break_min=/{print $2}')
  lba=$(echo "$DIST"      | awk -F= '/^longest_break_at=/{print $2}')

  local yt_pct=""
  if [ "$TOTAL" != "0" ] && [ "$TOTAL" != "0.0" ]; then
    yt_pct=$(awk -v yt="$TOTAL_YT" -v total="$TOTAL" 'BEGIN { printf "%.0f", yt/total*100 }' 2>/dev/null)
    [ -n "$yt_pct" ] && yt_pct=" ${yt_pct}%"
  fi

  cat <<EOF
---
type: retrace-summary
date: ${FILE_DATE}
total_active_hours: ${TOTAL}
youtube_hours: ${TOTAL_YT}
app_switches: ${switches}
switches_per_hour: ${sph}
longest_break_min: ${lbm}
longest_break_at: ${lba}
---

# スクリーン時間 - ${TARGET_DATE}

**${TOTAL}h** (YouTube ${TOTAL_YT}h${yt_pct}) ｜ アプリ切替 ${switches}回 (${sph}/h) ｜ 最長休憩 ${lbm}min (${lba})
EOF

  # === 本日のハイライト ===
  local docs sheets slides projs ghs meet_n
  docs=$(get_day_docs)
  sheets=$(get_day_sheets)
  slides=$(get_day_slides)
  projs=$(get_day_dev_projects)
  ghs=$(get_day_github_refs)
  meet_n=$(get_day_meet_count)
  meet_n=${meet_n:-0}

  if [ -n "$docs$sheets$slides$projs$ghs" ] || [ "$meet_n" != "0" ]; then
    echo ""
    echo "## 本日のハイライト"

    if [ -n "$projs" ]; then
      echo ""
      echo "### 開発プロジェクト"
      while IFS='|' read -r p _c; do
        [ -z "$p" ] && continue
        echo "- ${p}"
      done <<< "$projs"
    fi

    if [ -n "$ghs" ]; then
      echo ""
      echo "### GitHub"
      while IFS= read -r r; do
        [ -z "$r" ] && continue
        echo "- ${r}"
      done <<< "$ghs"
    fi

    if [ -n "$docs" ] || [ -n "$sheets" ] || [ -n "$slides" ]; then
      echo ""
      echo "### Google Workspace"
      [ -n "$docs" ] && while IFS= read -r d; do
        [ -z "$d" ] && continue
        echo "- 📄 ${d}"
      done <<< "$docs"
      [ -n "$sheets" ] && while IFS= read -r s; do
        [ -z "$s" ] && continue
        echo "- 📊 ${s}"
      done <<< "$sheets"
      [ -n "$slides" ] && while IFS= read -r s; do
        [ -z "$s" ] && continue
        echo "- 📽 ${s}"
      done <<< "$slides"
    fi

    if [ "$meet_n" != "0" ]; then
      echo ""
      echo "### Meet"
      echo "- ${meet_n}回"
    fi
  fi

  # === 時間帯別 ===
  echo ""
  echo "## 時間帯別"

  for hr in 0 2 4 6 8 10 12 14 16 18 20 22; do
    # 最初/最後の活動範囲外はスキップ
    if [ "$hr" -lt "$FIRST_ACTIVE" ] || [ "$hr" -gt "$LAST_ACTIVE" ]; then
      continue
    fi

    local block_end=$(( hr + 2 ))
    local label
    label=$(printf "%02d:00 - %02d:00" "$hr" "$block_end")
    local total_min=${BLOCK_TOTAL_MIN[$hr]:-0}
    local total_min_int=${total_min%.*}

    if [ "${total_min_int:-0}" -lt 1 ]; then
      echo ""
      echo "### ${label} 💤 非稼働"
      continue
    fi

    local yt_min=${BLOCK_YT_MIN[$hr]:-0}
    local yt_min_int=${yt_min%.*}
    local time_info
    if [ "${yt_min_int:-0}" -gt 0 ] 2>/dev/null; then
      local work_min=$(( total_min_int - yt_min_int ))
      time_info="${work_min}min + YT ${yt_min_int}min"
    else
      time_info="${total_min_int}min"
    fi

    local apps="${BLOCK_APPS[$hr]:-}"

    echo ""
    echo "### ${label} (${time_info})"
    [ -n "$apps" ] && echo "_${apps}_"

    # ウィンドウタイトル (YouTube/GWS除外)
    {
      while IFS= read -r win; do
        [ -z "$win" ] && continue
        clean_title "$win"
      done < <(get_window_titles "$hr")
    } | awk '!seen[$0]++' | while IFS= read -r line; do
      [ -n "$line" ] && echo "- ${line}"
    done

    # Google Workspace (block内)
    while IFS= read -r gws; do
      [ -z "$gws" ] && continue
      echo "- 📝 ${gws}"
    done < <(get_gworkspace_titles "$hr")

    # Meet (block内 回数)
    local mn
    mn=$(get_meet_count "$hr")
    if [ -n "$mn" ] && [ "$mn" != "0" ]; then
      echo "- 📞 Meet ×${mn}"
    fi

    # YouTube
    while IFS= read -r yt; do
      [ -z "$yt" ] && continue
      echo "- 📺 ${yt}"
    done < <(get_youtube_titles "$hr")
  done

  # === 集中セッション ===
  local sessions
  sessions=$(detect_focus_sessions)
  if [ -n "$sessions" ]; then
    echo ""
    echo "## 集中セッション"
    echo ""
    while IFS=$'\t' read -r start end mins frac app; do
      [ -z "$start" ] && continue
      local app_name
      app_name=$(normalize_app "$app")
      echo "- ${start}-${end} (${mins}min, ${frac}%) ${app_name}"
    done <<< "$sessions"
  fi

  echo ""
}

# ===============================================================
# ターミナル出力 (バー / カラー)
# ===============================================================
output_terminal() {
  echo ""
  echo "${B}${C}"
  hr
  center "RETRACE DAILY SUMMARY"
  center "$TARGET_DATE"
  hr
  echo "${R}"

  # 散漫度
  local DIST switches sph lbm lba
  DIST=$(calc_distraction_and_break)
  switches=$(echo "$DIST" | awk -F= '/^switches=/{print $2}')
  sph=$(echo "$DIST"      | awk -F= '/^switches_per_hour=/{print $2}')
  lbm=$(echo "$DIST"      | awk -F= '/^longest_break_min=/{print $2}')
  lba=$(echo "$DIST"      | awk -F= '/^longest_break_at=/{print $2}')

  echo "  ${D}Total active: ${W}${B}${TOTAL}h${R}    ${MAGENTA}YouTube: ${B}${TOTAL_YT}h${R}"
  echo "  ${D}Switches: ${W}${switches}${D} (${sph}/h)    Longest break: ${W}${lbm}min${D} (${lba})${R}"
  echo ""

  # ハイライト要約
  local projs ghs meet_n
  projs=$(get_day_dev_projects)
  ghs=$(get_day_github_refs)
  meet_n=$(get_day_meet_count)
  meet_n=${meet_n:-0}
  if [ -n "$projs" ]; then
    echo "  ${BLUE}${B}DEV:${R} $(echo "$projs" | cut -d'|' -f1 | tr '\n' ' ')"
  fi
  if [ -n "$ghs" ]; then
    echo "  ${BLUE}${B}GH :${R} $(echo "$ghs" | tr '\n' ' ')"
  fi
  if [ "$meet_n" != "0" ]; then
    echo "  ${BLUE}${B}Meet:${R} ${meet_n}回"
  fi
  echo ""

  for hr_b in 0 2 4 6 8 10 12 14 16 18 20 22; do
    if [ "$hr_b" -lt "$FIRST_ACTIVE" ] || [ "$hr_b" -gt "$LAST_ACTIVE" ]; then
      continue
    fi
    block_end=$(( hr_b + 2 ))
    label=$(printf "%02d:00 - %02d:00" "$hr_b" "$block_end")
    total_min=${BLOCK_TOTAL_MIN[$hr_b]:-0}
    total_min_int=${total_min%.*}

    if [ "${total_min_int:-0}" -lt 1 ]; then
      echo "  ${D}${label}  💤 非稼働${R}"
      echo ""
      continue
    fi

    apps="${BLOCK_APPS[$hr_b]:-}"
    yt_min=${BLOCK_YT_MIN[$hr_b]:-0}
    yt_min_int=${yt_min%.*}
    bar=$(make_bar "$total_min_int" "$MAX_BLOCK_MIN")

    yt_label=""
    if [ "${yt_min_int:-0}" -gt 0 ] 2>/dev/null; then
      yt_label="  ${MAGENTA}YouTube ${yt_min_int}min${R}"
    fi
    echo "  ${B}${Y}${label}${R}  ${D}(${total_min_int}min)${R}${yt_label}"

    if [ "${yt_min_int:-0}" -gt 0 ] 2>/dev/null && [ "$total_min_int" -gt 0 ]; then
      bar_max=$(( COLS - 6 ))
      work_min=$(( total_min_int - yt_min_int ))
      work_len=$(( work_min * bar_max / MAX_BLOCK_MIN ))
      yt_len=$(( yt_min_int * bar_max / MAX_BLOCK_MIN ))
      [ "$work_len" -lt 0 ] && work_len=0
      [ "$yt_len" -lt 1 ] && yt_len=1
      work_bar=$(printf '%*s' "$work_len" '' | tr ' ' '▓')
      yt_bar=$(printf '%*s' "$yt_len" '' | tr ' ' '▓')
      echo "  ${G}${work_bar}${MAGENTA}${yt_bar}${R}"
    else
      echo "  ${G}${bar}${R}"
    fi

    [ -n "$apps" ] && echo "  ${W}${apps}${R}"

    # ウィンドウタイトル
    {
      while IFS= read -r win; do
        [ -z "$win" ] && continue
        clean_title "$win"
      done < <(get_window_titles "$hr_b")
    } | awk '!seen[$0]++' | while IFS= read -r line; do
      [ -n "$line" ] && echo "  ${D}  ${line}${R}"
    done

    # GWS
    while IFS= read -r gws; do
      [ -z "$gws" ] && continue
      echo "  ${BLUE}  📝 ${gws}${R}"
    done < <(get_gworkspace_titles "$hr_b")

    # Meet
    mn=$(get_meet_count "$hr_b")
    if [ -n "$mn" ] && [ "$mn" != "0" ]; then
      echo "  ${BLUE}  📞 Meet ×${mn}${R}"
    fi

    # YouTube
    while IFS= read -r yt; do
      [ -z "$yt" ] && continue
      echo "  ${MAGENTA}  📺 ${yt}${R}"
    done < <(get_youtube_titles "$hr_b")
    echo ""
  done

  # 集中セッション
  local sessions
  sessions=$(detect_focus_sessions)
  if [ -n "$sessions" ]; then
    echo "  ${B}${C}集中セッション${R}"
    while IFS=$'\t' read -r start end mins frac app; do
      [ -z "$start" ] && continue
      app_name=$(normalize_app "$app")
      echo "  ${G}  ${start}-${end} ${R}${D}(${mins}min, ${frac}%)${R} ${W}${app_name}${R}"
    done <<< "$sessions"
    echo ""
  fi

  echo "${C}"
  hr
  echo "${R}"
}

# ===============================================================
# Main
# ===============================================================
if [ "$FORMAT" = "markdown" ]; then
  output_markdown
else
  if [ -t 1 ]; then
    output_terminal | less -RXF
  else
    output_terminal
  fi
fi
