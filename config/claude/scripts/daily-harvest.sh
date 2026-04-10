#!/usr/bin/env bash
# daily-harvest.sh
# 日付をまたいだ最初のスリープ復帰時に、昨日分の全日次タスクを実行する
#
# 実行内容:
#   1. Retrace サマリー（スクリーン時間）
#   2. Claude AI日誌
#   3. Codex AI日誌
#   4. Harvest（知識収穫）
#   5. 機械日報（events-build: git/shell/retrace）
#
# トリガー: launchd StartCalendarInterval (00:05)
# - Mac起動中 → 00:05に実行
# - Macスリープ中 → スリープ復帰直後に実行
# - 1日1回のみ実行（冪等性保証）

set -euo pipefail

# === 設定 ===
VAULT="$HOME/MyLife"
STATE_DIR="$HOME/.claude/scripts"
LAST_RUN_FILE="$STATE_DIR/.last-harvest-date"
LOG_FILE="$STATE_DIR/daily-harvest.log"
CLAUDE="$HOME/.local/bin/claude"
RETRACE_SCRIPT="$HOME/.claude/scripts/retrace-summary.sh"
CODEX_EXTRACT="$HOME/.claude/scripts/extract-codex-journal-data.sh"

TODAY=$(date +%Y-%m-%d)
YESTERDAY=$(date -v-1d +%Y-%m-%d)
FILE_YESTERDAY=$(echo "$YESTERDAY" | tr '-' '_')

# === ヘルパー ===
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

notify() {
    osascript -e "display notification \"$1\" with title \"Daily Harvest\"" 2>/dev/null || true
}

# === 冪等性チェック ===
if [ -f "$LAST_RUN_FILE" ] && [ "$(cat "$LAST_RUN_FILE")" = "$TODAY" ]; then
    exit 0
fi

log "=== Starting daily harvest for $YESTERDAY ==="
notify "昨日分（$YESTERDAY）の収穫を開始します..."

# === 1. Retrace サマリー → デイリーノートに追記 ===
DAILY_NOTE="$VAULT/pages/${FILE_YESTERDAY}.md"
if [ -x "$RETRACE_SCRIPT" ]; then
    # 冪等性: 既にデイリーノートにretraceセクションがあればスキップ
    if [ -f "$DAILY_NOTE" ] && grep -q '## スクリーン時間' "$DAILY_NOTE" 2>/dev/null; then
        log "retrace-summary: already in daily note, skipping"
    else
        log "Running retrace-summary for $YESTERDAY..."
        RETRACE_TMP="/tmp/retrace-${YESTERDAY}.md"
        if "$RETRACE_SCRIPT" --markdown "$YESTERDAY" 2>>"$LOG_FILE" > "$RETRACE_TMP"; then
            if [ -s "$RETRACE_TMP" ]; then
                # YAML frontmatter を除去し、見出しレベルを1段下げる（# → ##, ## → ###）
                RETRACE_BODY=$(awk 'BEGIN{fm=0} /^---$/{fm++; if(fm<=2) next} fm>=2' "$RETRACE_TMP" \
                    | sed 's/^# /## /' \
                    | sed 's/^## \([0-9]\)/### \1/')
                # デイリーノートが存在しない場合は作成
                if [ ! -f "$DAILY_NOTE" ]; then
                    cat > "$DAILY_NOTE" <<DNEOF
---
tags:
  - daily
  - $(echo "$YESTERDAY" | cut -d- -f1-2)
date: $(echo "$YESTERDAY" | tr '-' '/')
title: ${FILE_YESTERDAY}デイリーノート
---
DNEOF
                    log "Created daily note: $DAILY_NOTE"
                fi
                # 末尾の空行を整理してから追記
                printf '\n\n%s\n' "$RETRACE_BODY" >> "$DAILY_NOTE"
                log "retrace-summary appended to $DAILY_NOTE"
            else
                log "retrace-summary: no data for $YESTERDAY"
            fi
            rm -f "$RETRACE_TMP"
        else
            rm -f "$RETRACE_TMP"
            log "WARNING: retrace-summary failed (exit code: $?)"
        fi
    fi
else
    log "retrace-summary: script not found"
fi

# === 2. Claude AI日誌 ===
if [ -x "$CLAUDE" ]; then
    REALTIME_LOG="$VAULT/pages/${FILE_YESTERDAY}_realtime-log.md"
    if [ -f "$REALTIME_LOG" ]; then
        log "Running /ai-journal $YESTERDAY..."
        cd "$VAULT"
        if "$CLAUDE" -p "/ai-journal $YESTERDAY" \
            --model sonnet \
            --allowedTools "Bash,Read,Write,Edit" \
            >> "$LOG_FILE" 2>&1; then
            log "ai-journal completed"
        else
            log "WARNING: ai-journal failed (exit code: $?)"
        fi
    else
        log "ai-journal: no realtime-log for $YESTERDAY, skipping"
    fi

    # === 3. Codex AI日誌 ===
    CODEX_OUTPUT="$VAULT/pages/${FILE_YESTERDAY}_codex-ai-journals.md"
    if [ -x "$CODEX_EXTRACT" ] && [ ! -f "$CODEX_OUTPUT" ]; then
        log "Running codex-journal for $YESTERDAY..."
        EXTRACT_OUTPUT=$("$CODEX_EXTRACT" "$YESTERDAY" 2>/dev/null) || true
        if [ -n "$EXTRACT_OUTPUT" ]; then
            cd "$VAULT"
            PROMPT="以下のCodexログデータから、AI日誌を生成してください。

# 出力フォーマット

\`\`\`yaml
---
type: ai-journal
agent: codex
date: $FILE_YESTERDAY
projects: []
total_sessions: 0
total_conversations: 0
---
\`\`\`

の後に以下のMarkdown構造で出力してください:

# Codex AI日誌 - $FILE_YESTERDAY

## サマリー
（全プロジェクト通じた1日の概要を2-3文で）

---

## プロジェクト: プロジェクト名
**パス**: パス

### セッション N [HH:MM - HH:MM]
**タイトル**: スレッドタイトル
**目的**: セッションの目的
**操作**: 実行した操作のリスト

#### 会話ハイライト
> **ユーザー**: 質問の要約
> **Codex**: 回答の要約

**要約**: セッションの要約

---

## 横断サマリー
### 本日の統計（テーブル）
### 主なトピック
### 学んだこと
### 課題・継続事項

# 制約
- タイムスタンプはUTCなのでJST(+9h)に変換してHH:MM表示
- start_time/end_timeはUNIX秒
- phase: final_answer の内容を優先的にハイライト
- 500文字で切り詰められた内容を補完しない
- Markdownのみ出力（説明文不要）

# データ

$EXTRACT_OUTPUT"

            if "$CLAUDE" -p "$PROMPT" \
                --model sonnet \
                --no-session-persistence \
                --allowedTools "" \
                --permission-mode bypassPermissions \
                --system-prompt "あなたはAI日誌ジェネレーターです。入力データからMarkdown形式のAI日誌のみを出力します。出力は必ず --- で始まるYAML frontmatterから開始してください。説明文、メタテキスト、コメント等は一切出力しないでください。純粋なMarkdownのみを出力してください。" \
                > "$CODEX_OUTPUT" 2>>"$LOG_FILE"; then
                log "codex-journal saved to $CODEX_OUTPUT"
            else
                rm -f "$CODEX_OUTPUT"
                log "WARNING: codex-journal generation failed (exit code: $?)"
            fi
        else
            log "codex-journal: no sessions for $YESTERDAY"
        fi
    else
        log "codex-journal: skipped (already exists or extract script not found)"
    fi

    # === 4. Harvest ===
    REALTIME_LOG="$VAULT/pages/${FILE_YESTERDAY}_realtime-log.md"
    if [ -f "$REALTIME_LOG" ] || [ -f "$DAILY_NOTE" ]; then
        log "Running /harvest $YESTERDAY..."
        cd "$VAULT"
        if "$CLAUDE" -p "/harvest $YESTERDAY" \
            --model sonnet \
            --allowedTools "Read,Write,Edit,Glob,Grep,Bash" \
            >> "$LOG_FILE" 2>&1; then
            log "harvest completed"
        else
            log "WARNING: harvest failed (exit code: $?)"
        fi
    else
        log "harvest: no realtime-log or daily note for $YESTERDAY, skipping"
    fi
else
    log "ERROR: claude not found at $CLAUDE"
    notify "claude CLI が見つかりません"
fi

# === 5. 機械日報 (events) → デイリーノートに追記 ===
# raw-first な観測ログ。git / shell / retrace を時系列でマージして
# デイリーノートに `## 機械日報` セクションとして冪等追記する。既存の処理を壊さ
# ないため、失敗しても完了フラグには進む。
EVENTS_BUILD="$HOME/.claude/scripts/events-build.sh"
if [ -x "$EVENTS_BUILD" ]; then
    log "Running events-build for $YESTERDAY..."
    if "$EVENTS_BUILD" "$YESTERDAY" >> "$LOG_FILE" 2>&1; then
        log "events-build completed"
    else
        log "WARNING: events-build failed (exit code: $?)"
    fi
else
    log "events-build: script not found at $EVENTS_BUILD, skipping"
fi

# === 完了マーク ===
echo "$TODAY" > "$LAST_RUN_FILE"
log "=== Daily harvest completed ==="
notify "昨日分の収穫が完了しました"
