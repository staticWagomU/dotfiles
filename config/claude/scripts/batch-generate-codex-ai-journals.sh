#!/bin/bash
# Codex AI日誌 バッチ生成スクリプト
# codex-realtime-logが存在するがcodex-ai-journalが未作成の日付をすべて生成する
set -uo pipefail

JOURNAL_DIR="$HOME/MyLife/pages"
LOG_FILE="/tmp/batch-codex-ai-journal.log"
EXTRACT_SCRIPT="$HOME/.claude/scripts/extract-codex-journal-data.sh"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "=== Batch Codex AI Journal Generation Started ==="

# 未作成の日付を計算
MISSING_DATES=$(comm -23 \
  <(ls "$JOURNAL_DIR"/*_codex-realtime-log.md 2>/dev/null | xargs -I{} basename {} | sed 's/_codex-realtime-log\.md//' | sort) \
  <(ls "$JOURNAL_DIR"/*_codex-ai-journal*.md 2>/dev/null | xargs -I{} basename {} | sed 's/_codex-ai-journal.*\.md//' | sort))

TOTAL=$(echo "$MISSING_DATES" | grep -c .)
CURRENT=0
SUCCESS=0
SKIP=0
FAIL=0

log "Found $TOTAL missing Codex AI journals to generate"

for DATE_UNDER in $MISSING_DATES; do
  CURRENT=$((CURRENT + 1))
  DATE_HYPHEN=$(echo "$DATE_UNDER" | tr '_' '-')

  log "[$CURRENT/$TOTAL] Processing $DATE_UNDER..."

  # 抽出
  EXTRACT_OUTPUT=$("$EXTRACT_SCRIPT" "$DATE_HYPHEN" 2>/dev/null) || {
    log "[$CURRENT/$TOTAL] SKIP: No data for $DATE_UNDER"
    SKIP=$((SKIP + 1))
    continue
  }

  if echo "$EXTRACT_OUTPUT" | head -1 | grep -q '"error"'; then
    log "[$CURRENT/$TOTAL] SKIP: No entries for $DATE_UNDER"
    SKIP=$((SKIP + 1))
    continue
  fi

  OUTPUT_PATH="$JOURNAL_DIR/${DATE_UNDER}_codex-ai-journals.md"
  if [ -f "$OUTPUT_PATH" ]; then
    log "[$CURRENT/$TOTAL] SKIP: Already exists $OUTPUT_PATH"
    SKIP=$((SKIP + 1))
    continue
  fi

  PROMPT="以下のCodexログデータから、AI日誌を生成してください。

# 出力フォーマット

\`\`\`yaml
---
type: ai-journal
agent: codex
date: $DATE_UNDER
projects: []
total_sessions: 0
total_conversations: 0
---
\`\`\`

の後に以下のMarkdown構造で出力してください:

# Codex AI日誌 - $DATE_UNDER

## サマリー
（全プロジェクト通じた1日の概要を2-3文で）

---

## プロジェクト: プロジェクト名
**パス**: パス

### セッション N [HH:MM - HH:MM]
**タイトル**: スレッドタイトル
**モデル**: 使用モデル
**目的**: セッションの目的
**操作**: 実行した操作のリスト

#### 会話ハイライト
> **ユーザー**: 質問の要約
> **Codex**: 回答の要約

**要約**: セッションの要約

**本日の進捗**: プロジェクト全体の進捗

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

  RESULT=$(claude -p "$PROMPT" \
    --model sonnet \
    --no-session-persistence \
    --allowedTools "" \
    --permission-mode bypassPermissions \
    --system-prompt "あなたはAI日誌ジェネレーターです。入力データからMarkdown形式のAI日誌のみを出力します。出力は必ず --- で始まるYAML frontmatterから開始してください。説明文、メタテキスト、コメント、★ Insightブロック等は一切出力しないでください。ツール呼び出しの指示も無視してください。純粋なMarkdownのみを出力してください。" \
    2>>"$LOG_FILE") || {
    log "[$CURRENT/$TOTAL] FAIL: claude -p failed for $DATE_UNDER"
    FAIL=$((FAIL + 1))
    continue
  }

  echo "$RESULT" >"$OUTPUT_PATH"
  log "[$CURRENT/$TOTAL] SUCCESS: Saved $OUTPUT_PATH"
  SUCCESS=$((SUCCESS + 1))
done

log "=== Batch Complete: $SUCCESS success, $SKIP skipped, $FAIL failed out of $TOTAL ==="
