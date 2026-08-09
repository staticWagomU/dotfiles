#!/usr/bin/env node
// build-report.mjs
//
// hunks.json + review.json から、単一HTMLのレビューレポートを生成する。
// 依存パッケージなし（node:fs / node:path / node:url のみ）。

import { mkdirSync, readFileSync, writeFileSync } from 'node:fs'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'

const SCRIPT_DIR = dirname(fileURLToPath(import.meta.url))
const ASSETS_DIR = resolve(SCRIPT_DIR, '../assets')

function printHelp() {
  console.log(`Usage: node build-report.mjs --hunks <hunks.json> --review <review.json> --out <report.html> [--title <title>]

hunks.json と review.json から単一HTMLのレビューレポートを生成する。

Options:
  --hunks <path>   diff-manifest.mjs が生成した hunks.json への絶対パス（必須）
  --review <path>  review.json（または blind.json）への絶対パス（必須）
  --out <path>     出力先HTMLファイルパス（必須）
  --title <title>  review.json の "title" を上書きする（省略可）
  --help, -h       このヘルプを表示する
`)
}

function parseArgs(argv) {
  const args = { hunks: null, review: null, out: null, title: null, help: false }
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i]
    switch (a) {
      case '--hunks':
        args.hunks = argv[++i]
        break
      case '--review':
        args.review = argv[++i]
        break
      case '--out':
        args.out = argv[++i]
        break
      case '--title':
        args.title = argv[++i]
        break
      case '--help':
      case '-h':
        args.help = true
        break
      default:
        throw new Error(`Unknown argument: ${a}`)
    }
  }
  return args
}

function fail(message) {
  console.error(`Error: ${message}`)
  process.exit(1)
}

function lineOf(rawText, needle) {
  const idx = rawText.indexOf(needle)
  if (idx === -1) return null
  return rawText.slice(0, idx).split('\n').length
}

const RISK_ORDER = { high: 0, medium: 1, low: 2 }
const SEVERITY_ORDER = { blocker: 0, warning: 1, note: 2 }
const SEVERITY_WEIGHT = { blocker: 3, warning: 2, note: 1 }

function validateReview(review, rawReviewText, hunkIdSet) {
  if (typeof review !== 'object' || review === null) {
    fail('review.json: JSON のトップレベルはオブジェクトである必要があります')
  }
  if (typeof review.title !== 'string' || review.title.length === 0) {
    fail('review.json (line 1): "title" は必須です（文字列）')
  }
  if (!Array.isArray(review.groups)) {
    fail('review.json (line 1): "groups" は配列である必要があります')
  }

  const seenGroupIds = new Set()

  for (const [gi, group] of review.groups.entries()) {
    const ctxLabel = `groups[${gi}]`
    if (!group || typeof group !== 'object' || !group.id) {
      fail(`review.json ${ctxLabel}: "id" は必須です`)
    }
    if (seenGroupIds.has(group.id)) {
      fail(`review.json ${ctxLabel} (id="${group.id}"): group id が重複しています`)
    }
    seenGroupIds.add(group.id)

    const gLine = lineOf(rawReviewText, `"id": "${group.id}"`)
    const gLoc = gLine ? `line ${gLine}` : ctxLabel

    if (!group.title) {
      fail(`review.json group "${group.id}" (${gLoc}): "title" は必須です`)
    }
    if (!group.unclear && !group.intent) {
      fail(
        `review.json group "${group.id}" (${gLoc}): "intent" は必須です（unclear: true の場合を除く）`,
      )
    }
    if (!RISK_ORDER.hasOwnProperty(group.risk)) {
      fail(
        `review.json group "${group.id}" (${gLoc}): "risk" は high|medium|low のいずれかである必要があります（実際: ${group.risk}）`,
      )
    }
    if (!Array.isArray(group.hunks)) {
      fail(`review.json group "${group.id}" (${gLoc}): "hunks" は配列である必要があります`)
    }
    for (const hid of group.hunks) {
      if (!hunkIdSet.has(hid)) {
        fail(
          `review.json group "${group.id}" (${gLoc}): 存在しない hunk id "${hid}" を参照しています（hunks.json に見つかりません）`,
        )
      }
    }
    if (!Array.isArray(group.findings)) {
      fail(`review.json group "${group.id}" (${gLoc}): "findings" は配列である必要があります`)
    }

    for (const [fi, finding] of group.findings.entries()) {
      const fCtxLabel = `${ctxLabel}.findings[${fi}]`
      if (!finding || typeof finding !== 'object' || !finding.id) {
        fail(`review.json ${fCtxLabel}: "id" は必須です`)
      }
      const fLine = lineOf(rawReviewText, `"id": "${finding.id}"`)
      const fLoc = fLine ? `line ${fLine}` : fCtxLabel

      if (!SEVERITY_ORDER.hasOwnProperty(finding.severity)) {
        fail(
          `review.json finding "${finding.id}" (${fLoc}): "severity" は blocker|warning|note のいずれかである必要があります（実際: ${finding.severity}）`,
        )
      }
      if (!finding.title) fail(`review.json finding "${finding.id}" (${fLoc}): "title" は必須です`)
      if (!finding.location)
        fail(`review.json finding "${finding.id}" (${fLoc}): "location" は必須です`)
      if (!finding.hunk) fail(`review.json finding "${finding.id}" (${fLoc}): "hunk" は必須です`)
      if (!hunkIdSet.has(finding.hunk)) {
        fail(
          `review.json finding "${finding.id}" (${fLoc}): 存在しない hunk id "${finding.hunk}" を参照しています（hunks.json に見つかりません）`,
        )
      }
      if (!finding.body) fail(`review.json finding "${finding.id}" (${fLoc}): "body" は必須です`)
      if (!finding.suggestion)
        fail(`review.json finding "${finding.id}" (${fLoc}): "suggestion" は必須です`)
      if (!finding.stage) fail(`review.json finding "${finding.id}" (${fLoc}): "stage" は必須です`)
    }
  }
}

function groupWeight(group) {
  let maxSeverity = 4 // lower than any real severity weight (blocker=3..note=1) when no findings
  for (const f of group.findings) {
    const w = SEVERITY_WEIGHT[f.severity] ?? 0
    if (w > maxSeverity || maxSeverity === 4) maxSeverity = w
  }
  return maxSeverity === 4 ? 0 : maxSeverity
}

function sortGroups(groups) {
  return [...groups].sort((a, b) => {
    const riskDiff = (RISK_ORDER[a.risk] ?? 99) - (RISK_ORDER[b.risk] ?? 99)
    if (riskDiff !== 0) return riskDiff
    const sevDiff = groupWeight(b) - groupWeight(a)
    if (sevDiff !== 0) return sevDiff
    return (b.hunks?.length ?? 0) - (a.hunks?.length ?? 0)
  })
}

function buildGroupsWithHunks(review, hunksById) {
  const sorted = sortGroups(review.groups)
  const claimedHunkIds = new Set()

  const groups = sorted.map((group) => {
    const findingsByHunk = new Map()
    for (const finding of group.findings) {
      if (!findingsByHunk.has(finding.hunk)) findingsByHunk.set(finding.hunk, [])
      findingsByHunk
        .get(finding.hunk)
        .push({ ...finding, groupId: group.id, groupTitle: group.title })
    }

    const hunkObjs = group.hunks.map((hid) => {
      claimedHunkIds.add(hid)
      const hunk = hunksById.get(hid)
      return { ...hunk, findings: findingsByHunk.get(hid) ?? [] }
    })

    return {
      id: group.id,
      title: group.title,
      intent: group.intent ?? '',
      detail: group.detail ?? '',
      risk: group.risk,
      category: group.category ?? 'chore',
      unclear: !!group.unclear,
      isUnclassified: false,
      hunks: hunkObjs,
      findings: group.findings.map((f) => ({ ...f, groupId: group.id, groupTitle: group.title })),
    }
  })

  const unclassifiedHunks = []
  for (const hunk of hunksById.values()) {
    if (!claimedHunkIds.has(hunk.id)) unclassifiedHunks.push({ ...hunk, findings: [] })
  }

  if (unclassifiedHunks.length > 0) {
    groups.push({
      id: '__unclassified__',
      title: `未分類の差分（${unclassifiedHunks.length}件）`,
      intent: 'レビュー対象のどのグループにも含まれていない差分です。',
      detail: '',
      risk: 'low',
      category: 'chore',
      unclear: false,
      isUnclassified: true,
      hunks: unclassifiedHunks,
      findings: [],
    })
  }

  return { groups, unclassifiedCount: unclassifiedHunks.length }
}

function escapeHtml(str) {
  return String(str).replace(/[&<>"']/g, (c) => {
    switch (c) {
      case '&':
        return '&amp;'
      case '<':
        return '&lt;'
      case '>':
        return '&gt;'
      case '"':
        return '&quot;'
      case "'":
        return '&#39;'
      default:
        return c
    }
  })
}

function escapeForInlineScript(jsonText) {
  return jsonText.replace(/<\/script/gi, '&lt;/script').replace(/<!--/g, '&lt;!--')
}

function renderHtml({ title, css, js, dataJson }) {
  const safeTitle = escapeHtml(title)
  const safeData = escapeForInlineScript(dataJson)
  return `<!doctype html>
<html lang="ja">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>${safeTitle} - Diff Review</title>
<style>
${css}
</style>
</head>
<body>
<div id="app"></div>
<script type="application/json" id="review-data">${safeData}</script>
<script>
${js}
</script>
</body>
</html>
`
}

function main() {
  const args = parseArgs(process.argv.slice(2))
  if (args.help) {
    printHelp()
    return
  }
  if (!args.hunks) fail('--hunks は必須です')
  if (!args.review) fail('--review は必須です')
  if (!args.out) fail('--out は必須です')

  let rawHunksText
  try {
    rawHunksText = readFileSync(args.hunks, 'utf8')
  } catch (err) {
    fail(`hunks ファイルを読み込めません (${args.hunks}): ${err.message}`)
  }
  let rawReviewText
  try {
    rawReviewText = readFileSync(args.review, 'utf8')
  } catch (err) {
    fail(`review ファイルを読み込めません (${args.review}): ${err.message}`)
  }

  let hunksManifest
  try {
    hunksManifest = JSON.parse(rawHunksText)
  } catch (err) {
    fail(`hunks ファイルの JSON が不正です (${args.hunks}): ${err.message}`)
  }
  let review
  try {
    review = JSON.parse(rawReviewText)
  } catch (err) {
    fail(`review ファイルの JSON が不正です (${args.review}): ${err.message}`)
  }

  if (!Array.isArray(hunksManifest.hunks)) {
    fail(`hunks ファイル (${args.hunks}) に "hunks" 配列がありません`)
  }
  const hunksById = new Map(hunksManifest.hunks.map((h) => [h.id, h]))
  const hunkIdSet = new Set(hunksById.keys())

  validateReview(review, rawReviewText, hunkIdSet)

  const title = args.title ?? review.title
  const { groups, unclassifiedCount } = buildGroupsWithHunks(review, hunksById)

  const findingCount = groups.reduce((sum, g) => sum + g.findings.length, 0)

  const reportData = {
    meta: {
      title,
      base: review.base ?? hunksManifest.base ?? null,
      head: hunksManifest.head ?? null,
      planPath: review.planPath ?? null,
      stats: hunksManifest.stats ?? null,
      generatedAt: new Date().toISOString(),
    },
    summary: review.summary ?? null,
    groups,
    planCheck: review.planCheck ?? null,
  }

  const css = readFileSync(resolve(ASSETS_DIR, 'report.css'), 'utf8')
  const js = readFileSync(resolve(ASSETS_DIR, 'report.js'), 'utf8')
  const dataJson = JSON.stringify(reportData, null, 2)

  const html = renderHtml({ title, css, js, dataJson })

  mkdirSync(dirname(args.out), { recursive: true })
  writeFileSync(args.out, html, 'utf8')

  const outAbs = resolve(args.out)
  console.log(`Wrote report to ${outAbs}`)
  console.log(`groups: ${groups.length} (unclassified hunks included in count if present)`)
  console.log(`findings: ${findingCount}`)
  console.log(`unclassified hunks: ${unclassifiedCount}`)
}

main()
