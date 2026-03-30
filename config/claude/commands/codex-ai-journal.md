---
allowed-tools: Bash(cat:*), Bash(jq:*), Bash(date:*), Bash(mkdir:*), Bash(ls:*), Bash(~/.claude/scripts/*), Read, Write, Edit, AskUserQuestion
description: Generate AI journal from Codex history logs
argument-hint: [YYYY-MM-DD|today|yesterday]
model: sonnet
---

<purpose>
Codexの履歴ログから、指定日のAI日誌を自動生成します。
</purpose>

<context>
  <argument>
$ARGUMENTS

- `YYYY-MM-DD`: 指定した日付の日誌を生成（例: 2026-01-05）
- `today`: 本日の日誌を生成
- `yesterday`: 昨日の日誌を生成
- 引数なし: 本日の日誌を生成
  </argument>

  <datasource>
1. `~/.codex/state_5.sqlite` - スレッドメタデータ（cwd, title, timestamps）
2. `~/.codex/sessions/**/rollout-*.jsonl` - セッション会話（user_message/agent_message）
  </datasource>

  <output-path>`~/MyLife/pages/YYYY_MM_DD_codex-ai-journals.md`</output-path>
</context>

<workflow>
  <phase name="extract">
    <objective>前処理スクリプトでログを抽出</objective>
    <step>以下のコマンドを実行して、構造化されたログデータを取得:
```bash
~/.claude/scripts/extract-codex-journal-data.sh "$ARGUMENTS"
```</step>
    <step>このスクリプトは以下のJSON構造を出力します:
- `meta`: 日付、パス、統計情報（`total_conversations` を含む）
- `data`: プロジェクト別・セッション別の詳細データ
  - `prompts`: ユーザープロンプト一覧
  - `conversations`: user/assistant の会話ログ（`phase` フィールドで `commentary`/`final_answer` を区別）</step>
    <step>エラー時: スクリプトがエラーを返した場合は、ユーザーに通知して終了。</step>
  </phase>

  <phase name="realtime-check">
    <objective>リアルタイムログの確認（オプション）</objective>
    <step>同日の `YYYY_MM_DD_codex-realtime-log.md` が存在する場合、その内容も参照可能。</step>
    <step>このファイルは `codex-watch-and-save.sh` によってリアルタイムで生成される。</step>
  </phase>

  <phase name="existing-check">
    <objective>既存ファイルの確認</objective>
    <step>`meta.existing_file` が `true` の場合、AskUserQuestion ツールで以下を確認:
1. **上書き**: 既存の内容を完全に置き換える
2. **追記**: 既存の内容の末尾に新しいセッション情報を追加
3. **キャンセル**: 処理を中止</step>
  </phase>

  <phase name="generate">
    <objective>日誌の生成</objective>
    <step>抽出されたデータを元に、以下のフォーマットで日誌を生成する。</step>
    <step>Codex特有のフィールド:
- `phase: commentary` → Codexの思考過程（途中経過）
- `phase: final_answer` → Codexの最終回答
- `model` → 使用モデル（例: gpt-5.4）
- `title` → Codexが自動生成したスレッドタイトル</step>
  </phase>

  <phase name="save">
    <objective>ファイルの保存</objective>
    <step>```bash
mkdir -p ~/MyLife/pages
```</step>
    <step>Write ツールを使用して `meta.journal_path` に保存。</step>
  </phase>
</workflow>

<output>
  <format name="yaml-frontmatter">
```yaml
---
type: ai-journal
agent: codex
date: YYYY_MM_DD
projects:
  - name: プロジェクト名
total_sessions: 合計セッション数
total_conversations: 合計会話数
---
```
  </format>

  <format name="markdown-body">
```markdown
# Codex AI日誌 - YYYY_MM_DD

## サマリー
<!-- 全プロジェクト通じた1日の概要を2-3文で -->

---

## プロジェクト: プロジェクト名

**パス**: `パス`

### セッション N [HH:MM - HH:MM]
**タイトル**: Codexが生成したスレッドタイトル
**モデル**: 使用モデル
**目的**: セッションの目的（promptsから推測）

**操作**:
- 実行した操作のリスト

#### 会話ハイライト
<!-- conversations データから、重要な質問と回答をピックアップ -->
<!-- phase: final_answer の回答を優先して要約 -->

> **ユーザー**: [質問の要約]
> **Codex**: [回答の要約]

**要約**: セッションの要約

**本日の進捗**: プロジェクト全体の進捗

---

## 横断サマリー

### 本日の統計
| プロジェクト | セッション | 会話数 | モデル | 主な操作 | 備考 |
|-------------|-----------|-------|--------|---------|------|

### 主なトピック
- トピック1
- トピック2

### 学んだこと
<!-- Codex との会話から得られた知見 -->
- 知見1
- 知見2

### 課題・継続事項
- [ ] 課題1
- [ ] 課題2
```
  </format>
</output>

<constraints>
  <must>プロジェクト名は `data[].project_name` を使用</must>
  <must>タイムスタンプはUTC ISO8601形式で提供されるので、JST (UTC+9) に変換して `HH:MM` 形式で表示</must>
  <must>start_time/end_time はUNIX秒で提供されるので、JST に変換</must>
  <must>セッションは時系列順に並べる</must>
  <must>`phase: final_answer` の内容を優先的にハイライトに採用</must>
  <avoid>会話データが500文字で切り詰められている場合（`...` で終わる）に、切り詰め部分を補完すること</avoid>
</constraints>

上記のフローに従って、$ARGUMENTS の日付のCodex AI日誌を生成してください。
