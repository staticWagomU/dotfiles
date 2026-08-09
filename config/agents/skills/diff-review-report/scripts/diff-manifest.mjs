#!/usr/bin/env node
// diff-manifest.mjs
//
// git diff を解析し、hunk 単位で安定IDを振った JSON マニフェストを生成する。
// 依存パッケージなし（node:child_process / node:fs / node:path のみ）。

import { execFileSync } from 'node:child_process'
import { mkdirSync, writeFileSync } from 'node:fs'
import { dirname } from 'node:path'

function printHelp() {
  console.log(`Usage: node diff-manifest.mjs [options]

git diff を解析し、hunk 単位で安定ID（h001 形式）を振った JSON マニフェストを生成する。

Options:
  --base <ref>   比較元の ref（既定: HEAD）
  --head <ref>   比較先の ref（既定: 省略。省略時は作業ツリーと比較する = "git diff <base>"。
                 ステージ済み・未ステージ済みの変更を両方含む）
                 指定時は 2点比較 "git diff <base> <head>" を使う（3点比較 "..." は使わない）
  --cwd <path>   git を実行するディレクトリ（既定: カレントディレクトリ）
  --out <path>   出力先ファイルパス（省略時は標準出力に JSON を出力する）
  --list         人間可読の1行サマリ（ID / ファイル / ヘッダ / +N -N）を標準出力に出す
  --help, -h     このヘルプを表示する

Examples:
  node diff-manifest.mjs --base HEAD --out /tmp/review/hunks.json
  node diff-manifest.mjs --base origin/develop --head HEAD --list
`)
}

function parseArgs(argv) {
  const args = { base: 'HEAD', head: null, cwd: process.cwd(), out: null, list: false, help: false }
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i]
    switch (a) {
      case '--base':
        args.base = argv[++i]
        break
      case '--head':
        args.head = argv[++i]
        break
      case '--cwd':
        args.cwd = argv[++i]
        break
      case '--out':
        args.out = argv[++i]
        break
      case '--list':
        args.list = true
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

function runGitDiff({ cwd, base, head }) {
  const gitArgs = ['diff', '--no-color', '--no-ext-diff', '-U5', '-M']
  gitArgs.push(base)
  if (head) gitArgs.push(head)
  try {
    return execFileSync('git', gitArgs, {
      cwd,
      encoding: 'utf8',
      maxBuffer: 1024 * 1024 * 200,
    })
  } catch (err) {
    throw new Error(`git diff failed (cwd=${cwd}, args=${gitArgs.join(' ')}): ${err.message}`)
  }
}

function stripPrefix(p, prefix) {
  return p.startsWith(prefix) ? p.slice(prefix.length) : p
}

const HUNK_HEADER_RE = /^@@ -(\d+)(?:,(\d+))?\s\+(\d+)(?:,(\d+))?\s@@/
const GIT_LINE_RE = /^diff --git a\/(.*) b\/(.*)$/
const BINARY_LINE_RE = /^Binary files (.+) and (.+) differ$/

function parseDiff(raw) {
  const lines = raw.split('\n')
  const files = []
  const hunks = []
  let hunkCounter = 0
  let i = 0

  while (i < lines.length) {
    const line = lines[i]
    if (!line.startsWith('diff --git ')) {
      i++
      continue
    }

    const gitLineMatch = GIT_LINE_RE.exec(line)
    let fallbackOld = gitLineMatch ? gitLineMatch[1] : null
    let fallbackNew = gitLineMatch ? gitLineMatch[2] : null
    i++

    let status = 'modified'
    let binary = false
    let renameFromPath = null
    let renameToPath = null
    let headerOldPath = null
    let headerNewPath = null
    const fileHunks = []
    let insertions = 0
    let deletions = 0

    while (i < lines.length && !lines[i].startsWith('diff --git ')) {
      const l = lines[i]

      if (l.startsWith('new file mode')) {
        status = 'added'
        i++
        continue
      }
      if (l.startsWith('deleted file mode')) {
        status = 'deleted'
        i++
        continue
      }
      if (l.startsWith('rename from ')) {
        renameFromPath = l.slice('rename from '.length)
        status = 'renamed'
        i++
        continue
      }
      if (l.startsWith('rename to ')) {
        renameToPath = l.slice('rename to '.length)
        status = 'renamed'
        i++
        continue
      }
      if (l.startsWith('Binary files ')) {
        binary = true
        const m = BINARY_LINE_RE.exec(l)
        if (m) {
          if (m[1] !== '/dev/null') headerOldPath = stripPrefix(m[1], 'a/')
          if (m[2] !== '/dev/null') headerNewPath = stripPrefix(m[2], 'b/')
        }
        i++
        continue
      }
      if (l.startsWith('--- ')) {
        const p = l.slice(4)
        if (p !== '/dev/null') headerOldPath = stripPrefix(p, 'a/')
        i++
        continue
      }
      if (l.startsWith('+++ ')) {
        const p = l.slice(4)
        if (p !== '/dev/null') headerNewPath = stripPrefix(p, 'b/')
        i++
        continue
      }
      if (l.startsWith('@@ ')) {
        const m = HUNK_HEADER_RE.exec(l)
        if (!m) {
          i++
          continue
        }
        const oldStart = Number(m[1])
        const oldLines = m[2] !== undefined ? Number(m[2]) : 1
        const newStart = Number(m[3])
        const newLines = m[4] !== undefined ? Number(m[4]) : 1
        i++

        const hunkLines = []
        let oldNo = oldStart
        let newNo = newStart
        while (i < lines.length) {
          const hl = lines[i]
          if (hl.startsWith('@@ ') || hl.startsWith('diff --git ')) break
          if (hl.startsWith('\\ No newline at end of file')) {
            i++
            continue
          }
          if (hl.length === 0) break // trailing split artifact at end of diff output
          const marker = hl[0]
          const text = hl.slice(1)
          if (marker === ' ') {
            hunkLines.push({ type: 'context', oldNo, newNo, text })
            oldNo++
            newNo++
          } else if (marker === '+') {
            hunkLines.push({ type: 'add', oldNo: null, newNo, text })
            newNo++
            insertions++
          } else if (marker === '-') {
            hunkLines.push({ type: 'del', oldNo, newNo: null, text })
            oldNo++
            deletions++
          } else {
            break // unknown marker: defensively stop this hunk's body
          }
          i++
        }

        hunkCounter++
        const id = 'h' + String(hunkCounter).padStart(3, '0')
        fileHunks.push({ id, header: l, oldStart, oldLines, newStart, newLines, lines: hunkLines })
        continue
      }

      i++
    }

    let path
    let oldPath = null
    if (status === 'renamed') {
      path = renameToPath ?? fallbackNew
      oldPath = renameFromPath ?? fallbackOld
    } else if (status === 'added') {
      path = headerNewPath ?? fallbackNew
    } else if (status === 'deleted') {
      path = headerOldPath ?? fallbackOld
    } else {
      path = headerNewPath ?? headerOldPath ?? fallbackNew ?? fallbackOld
    }

    files.push({
      path,
      oldPath,
      status,
      binary,
      hunkIds: fileHunks.map((h) => h.id),
      insertions,
      deletions,
    })
    hunks.push(...fileHunks)
  }

  return { files, hunks }
}

function main() {
  const args = parseArgs(process.argv.slice(2))
  if (args.help) {
    printHelp()
    return
  }

  const raw = runGitDiff({ cwd: args.cwd, base: args.base, head: args.head })
  const { files, hunks } = parseDiff(raw)
  const stats = {
    files: files.length,
    hunks: hunks.length,
    insertions: files.reduce((s, f) => s + f.insertions, 0),
    deletions: files.reduce((s, f) => s + f.deletions, 0),
  }
  const manifest = {
    base: args.base,
    head: args.head ?? null,
    generatedBy: 'diff-manifest.mjs',
    stats,
    files,
    hunks,
  }

  if (args.list) {
    for (const hunk of hunks) {
      const file = files.find((f) => f.hunkIds.includes(hunk.id))
      const added = hunk.lines.filter((l) => l.type === 'add').length
      const deleted = hunk.lines.filter((l) => l.type === 'del').length
      console.log(`${hunk.id}  ${file ? file.path : '?'}  ${hunk.header}  +${added} -${deleted}`)
    }
  }

  const json = JSON.stringify(manifest, null, 2)
  if (args.out) {
    mkdirSync(dirname(args.out), { recursive: true })
    writeFileSync(args.out, json + '\n', 'utf8')
    console.error(`Wrote ${hunks.length} hunks (${files.length} files) to ${args.out}`)
  } else if (!args.list) {
    console.log(json)
  }
}

main()
