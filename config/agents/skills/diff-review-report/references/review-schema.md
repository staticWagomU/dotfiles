# review.json / blind.json スキーマ

`diff-review-report` の Step 1 (`blind.json`) と Step 2 (`review.json`) が出力する JSON のスキーマ。
フィールドは以下のみを使う（余計なフィールドを増やさない）。

```jsonc
{
  "title": "string  レポート見出し（例: app/system URL整理の未ステージ差分レビュー）",
  "base": "string  比較対象 ref",
  "planPath": "string | null",
  "summary": "string  差分全体の要約 2〜4文",
  "groups": [
    {
      "id": "g1",
      "title": "URL・ホスト判定の共通基盤",
      "intent": "deployment mode ごとのURL生成とhost判定を一か所に集約し、legacy-path と subdomain を安全に切り替える。",
      "detail": "何をどう変えたかの補足 1〜3文",
      "risk": "high | medium | low",
      "category": "feat | fix | refactor | test | docs | chore",
      "unclear": false,
      "hunks": ["h079", "h080"],
      "findings": [
        {
          "id": "f1",
          "severity": "blocker | warning | note",
          "title": "省略可能な別フラグが context-only 処理の抜けを隠します",
          "location": "apps/web/src/app/api/routes/ai-route-message-utils.ts (新L109〜)",
          "hunk": "h010",
          "body": "失敗シナリオを含む指摘本文",
          "suggestion": "改善案",
          "stage": "blind | plan-aware",
          "planVerdict": "kept | demoted | resolved | null",
          "planNote": "plan 上は意図的な変更だが、実装として改善を求める"
        }
      ]
    }
  ],
  "planCheck": {
    "items": [
      { "planItem": "planの項目名", "status": "done | partial | missing | deviated", "note": "根拠" }
    ]
  }
}
```

## `blind.json`（Step 1 出力）との違い

- `blind.json` は **`planPath` / `planVerdict` / `planNote` / `planCheck` を含まない。**
- `blind.json` の各 finding の `stage` は常に `"blind"`。
- `blind.json` の各 finding は `planVerdict` フィールド自体を持たない（`null` を明示するのではなく、キーごと存在しない）。

## `review.json`（Step 2 出力）で追加されるもの

- 各 finding に `stage`（`"blind"` のまま、または新規追加分は `"plan-aware"`）、`planVerdict`、（`demoted` のときのみ）`planNote` を追加する。
- トップレベルに `planPath` と `planCheck` を追加する。plan が存在しない場合は `planPath: null` とし `planCheck` は省略してよい（`build-report.mjs` は `planCheck` 欠落時にセクション03を非表示にする）。

## 必須フィールド（`build-report.mjs` が検証する）

- トップレベル: `title`（string）, `groups`（array）。
- 各 group: `id`, `title`, `risk`（`high|medium|low`）, `hunks`（array, 実在する hunk ID のみ）, `findings`（array）。`intent` は **`unclear: true` でない限り必須**。
- 各 finding: `id`, `severity`（`blocker|warning|note`）, `title`, `location`, `hunk`（実在する hunk ID）, `body`, `suggestion`, `stage`。

必須フィールドが欠落している場合、または存在しない hunk ID を参照している場合、`build-report.mjs` は **行番号つきの明確なエラーメッセージを出して `exit 1`** する。黙って空欄のまま描画することはない。

## `hunks.json`（`diff-manifest.mjs` の出力。参考）

```jsonc
{
  "base": "HEAD", "head": null, "generatedBy": "diff-manifest.mjs",
  "stats": { "files": 107, "hunks": 268, "insertions": 1468, "deletions": 812 },
  "files": [
    { "path": "webapp/src/lib/auth.ts", "oldPath": null, "status": "modified", "binary": false, "hunkIds": ["h001"], "insertions": 3, "deletions": 1 }
  ],
  "hunks": [
    {
      "id": "h001", "file": "webapp/src/lib/auth.ts", "header": "@@ -1,10 +1,13 @@",
      "oldStart": 1, "oldLines": 10, "newStart": 1, "newLines": 13,
      "lines": [
        { "type": "context", "oldNo": 1, "newNo": 1, "text": "import Cookies from 'js-cookie';" }
      ]
    }
  ]
}
```

`review.json` の `hunks` 配列に書く ID はすべて `hunks.json` の `hunks[].id` から**そのまま**転記する。推測で新しい ID を作らない。
