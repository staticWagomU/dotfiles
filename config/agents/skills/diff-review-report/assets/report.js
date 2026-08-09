;(function () {
  'use strict'

  // ---------- DOM helper (never uses innerHTML with dynamic content) ----------
  function h(tag, props, children) {
    props = props || {}
    const el = document.createElement(tag)
    for (const key of Object.keys(props)) {
      const value = props[key]
      if (value === undefined || value === null) continue
      if (key === 'class') el.className = value
      else if (key === 'text') el.textContent = value
      else if (key.indexOf('on') === 0 && typeof value === 'function') {
        el.addEventListener(key.slice(2).toLowerCase(), value)
      } else if (key === 'dataset') {
        for (const dk of Object.keys(value)) el.dataset[dk] = value[dk]
      } else {
        el.setAttribute(key, value)
      }
    }
    if (children) {
      const list = Array.isArray(children) ? children : [children]
      for (const c of list) {
        if (c === null || c === undefined) continue
        el.appendChild(typeof c === 'string' ? document.createTextNode(c) : c)
      }
    }
    return el
  }

  // ---------- Load embedded data ----------
  const dataEl = document.getElementById('review-data')
  const reportData = JSON.parse(dataEl.textContent)

  const SEVERITY_LABEL = { blocker: '重大', warning: '警告', note: '情報' }
  const SEVERITY_ORDER = { blocker: 0, warning: 1, note: 2 }
  const RISK_LABEL = { high: '高リスク', medium: '中リスク', low: '低リスク' }
  const PLAN_STATUS_LABEL = {
    done: '完了',
    partial: '一部対応',
    missing: '未対応',
    deviated: '逸脱',
  }

  // ---------- State (persisted to localStorage) ----------
  function hashKey(str) {
    let hash = 5381
    for (let i = 0; i < str.length; i++) {
      hash = (hash << 5) + hash + str.charCodeAt(i)
      hash |= 0
    }
    return (hash >>> 0).toString(16)
  }

  const storageKey =
    'diff-review-report:' +
    hashKey((reportData.meta.title || '') + '|' + (reportData.meta.base || ''))

  function defaultState() {
    return { findings: {}, groups: {}, globalComment: '' }
  }

  function loadState() {
    try {
      const raw = localStorage.getItem(storageKey)
      if (!raw) return defaultState()
      const parsed = JSON.parse(raw)
      return {
        findings: parsed.findings || {},
        groups: parsed.groups || {},
        globalComment: parsed.globalComment || '',
      }
    } catch (e) {
      return defaultState()
    }
  }

  let state = loadState()

  function saveState() {
    try {
      localStorage.setItem(storageKey, JSON.stringify(state))
    } catch (e) {
      // localStorage unavailable (private mode, etc.) - state stays in-memory only
    }
  }

  function getFindingState(id) {
    return state.findings[id] || { decision: null, comment: '' }
  }

  // ---------- Cross-instance sync registry ----------
  const findingRegistry = new Map() // id -> Set<updateFn>
  function registerFindingInstance(id, updateFn) {
    if (!findingRegistry.has(id)) findingRegistry.set(id, new Set())
    findingRegistry.get(id).add(updateFn)
  }
  function syncFindingUI(id) {
    const fns = findingRegistry.get(id)
    if (fns) fns.forEach((fn) => fn())
  }

  function setDecision(id, decision) {
    const cur = getFindingState(id)
    state.findings[id] = { decision, comment: cur.comment || '' }
    saveState()
    syncFindingUI(id)
    updateHeaderProgress()
    updateSection05Counts()
  }

  function setComment(id, text) {
    const cur = getFindingState(id)
    state.findings[id] = { decision: cur.decision || null, comment: text }
    saveState()
    syncFindingUI(id)
    updateSection05Counts()
  }

  function setGroupApproved(id, approved) {
    state.groups[id] = { approved }
    saveState()
    updateHeaderProgress()
  }

  // ---------- Flat list of all findings across groups ----------
  const allFindings = []
  for (const group of reportData.groups) {
    for (const finding of group.findings) allFindings.push(finding)
  }

  // ---------- Word-level diff (LCS-based) for adjacent del/add line pairs ----------
  function tokenize(text) {
    return text.split(/(\s+)/).filter((t) => t.length > 0)
  }

  function diffWords(oldText, newText) {
    const a = tokenize(oldText)
    const b = tokenize(newText)
    const n = a.length
    const m = b.length
    if (n * m > 6000) {
      // guard against pathological perf on very long lines
      return {
        oldParts: [{ t: oldText, eq: false }],
        newParts: [{ t: newText, eq: false }],
      }
    }
    const dp = []
    for (let i = 0; i <= n; i++) dp.push(new Int32Array(m + 1))
    for (let i = n - 1; i >= 0; i--) {
      for (let j = m - 1; j >= 0; j--) {
        dp[i][j] = a[i] === b[j] ? dp[i + 1][j + 1] + 1 : Math.max(dp[i + 1][j], dp[i][j + 1])
      }
    }
    const oldParts = []
    const newParts = []
    let i = 0
    let j = 0
    while (i < n && j < m) {
      if (a[i] === b[j]) {
        oldParts.push({ t: a[i], eq: true })
        newParts.push({ t: b[j], eq: true })
        i++
        j++
      } else if (dp[i + 1][j] >= dp[i][j + 1]) {
        oldParts.push({ t: a[i], eq: false })
        i++
      } else {
        newParts.push({ t: b[j], eq: false })
        j++
      }
    }
    while (i < n) {
      oldParts.push({ t: a[i], eq: false })
      i++
    }
    while (j < m) {
      newParts.push({ t: b[j], eq: false })
      j++
    }
    return { oldParts, newParts }
  }

  function renderTextWithParts(container, parts, addClass) {
    for (const part of parts) {
      if (part.eq) {
        container.appendChild(document.createTextNode(part.t))
      } else {
        container.appendChild(h('span', { class: addClass }, part.t))
      }
    }
  }

  // ---------- Diff hunk rendering ----------
  function renderDiffRow(line, type, parts) {
    const row = h('div', { class: 'diff-row type-' + type })
    row.appendChild(
      h('span', {
        class: 'ln ln-old',
        text: line.oldNo !== null && line.oldNo !== undefined ? String(line.oldNo) : '',
      }),
    )
    row.appendChild(
      h('span', {
        class: 'ln ln-new',
        text: line.newNo !== null && line.newNo !== undefined ? String(line.newNo) : '',
      }),
    )
    const marker = type === 'add' ? '+' : type === 'del' ? '-' : ' '
    row.appendChild(h('span', { class: 'marker', text: marker }))
    const textEl = h('span', { class: 'text' })
    if (parts) {
      renderTextWithParts(textEl, parts, type === 'add' ? 'diff-inline-add' : 'diff-inline-del')
    } else {
      textEl.textContent = line.text
    }
    row.appendChild(textEl)
    return row
  }

  function renderHunkLines(lines) {
    const container = h('div', { class: 'diff-lines' })
    let idx = 0
    while (idx < lines.length) {
      const line = lines[idx]
      if (line.type === 'del') {
        const delRun = []
        let j = idx
        while (j < lines.length && lines[j].type === 'del') {
          delRun.push(lines[j])
          j++
        }
        const addRun = []
        let k = j
        while (k < lines.length && lines[k].type === 'add') {
          addRun.push(lines[k])
          k++
        }
        const pairCount = Math.min(delRun.length, addRun.length)
        for (let p = 0; p < pairCount; p++) {
          const { oldParts, newParts } = diffWords(delRun[p].text, addRun[p].text)
          container.appendChild(renderDiffRow(delRun[p], 'del', oldParts))
          container.appendChild(renderDiffRow(addRun[p], 'add', newParts))
        }
        for (let p = pairCount; p < delRun.length; p++)
          container.appendChild(renderDiffRow(delRun[p], 'del', null))
        for (let p = pairCount; p < addRun.length; p++)
          container.appendChild(renderDiffRow(addRun[p], 'add', null))
        idx = k
      } else {
        container.appendChild(renderDiffRow(line, line.type, null))
        idx++
      }
    }
    return container
  }

  function renderHunk(hunk) {
    const wrap = h('div', { class: 'diff-hunk', id: 'hunk-' + hunk.id })
    const head = h('div', { class: 'diff-hunk-head' })
    head.appendChild(h('span', { class: 'hunk-id', text: hunk.id }))
    head.appendChild(h('span', { class: 'hunk-file', text: hunk.file }))
    head.appendChild(h('span', { class: 'hunk-header', text: hunk.header }))
    wrap.appendChild(head)
    wrap.appendChild(renderHunkLines(hunk.lines))
    return wrap
  }

  // ---------- Finding card rendering ----------
  function renderFindingCard(finding) {
    const card = h('div', { class: 'finding-card', dataset: { findingId: finding.id } })

    const head = h('div', { class: 'finding-head' })
    head.appendChild(
      h('span', {
        class: 'badge severity-' + finding.severity,
        text: SEVERITY_LABEL[finding.severity] || finding.severity,
      }),
    )
    head.appendChild(h('span', { class: 'finding-title', text: finding.title }))
    if (finding.planVerdict === 'demoted') {
      head.appendChild(
        h('span', { class: 'badge badge-demoted', text: 'plan上は意図的（要判断）' }),
      )
    }
    card.appendChild(head)

    card.appendChild(
      h('p', { class: 'finding-location', text: finding.location + ' [' + finding.hunk + ']' }),
    )
    card.appendChild(h('p', { class: 'finding-body', text: finding.body }))

    const suggestion = h('p', { class: 'finding-suggestion' })
    suggestion.appendChild(h('strong', {}, '改善案: '))
    suggestion.appendChild(document.createTextNode(finding.suggestion))
    card.appendChild(suggestion)

    if (finding.planNote) {
      const note = h('p', { class: 'finding-plannote' })
      note.appendChild(h('strong', {}, '備考: '))
      note.appendChild(document.createTextNode(finding.planNote))
      card.appendChild(note)
    }

    const decisionRow = h('div', { class: 'finding-decision-row' })
    const adoptBtn = h('button', {
      type: 'button',
      class: 'btn btn-adopt',
      text: '採用',
      onClick: () => setDecision(finding.id, 'adopted'),
    })
    const rejectBtn = h('button', {
      type: 'button',
      class: 'btn btn-reject',
      text: '却下',
      onClick: () => setDecision(finding.id, 'rejected'),
    })
    const holdBtn = h('button', {
      type: 'button',
      class: 'btn btn-hold',
      text: '保留',
      onClick: () => setDecision(finding.id, null),
    })
    decisionRow.appendChild(adoptBtn)
    decisionRow.appendChild(rejectBtn)
    decisionRow.appendChild(holdBtn)
    card.appendChild(decisionRow)

    const textarea = h('textarea', {
      class: 'finding-comment',
      placeholder: 'コメント（任意）',
      rows: '2',
    })
    textarea.addEventListener('input', () => setComment(finding.id, textarea.value))
    card.appendChild(textarea)
    card._commentTextarea = textarea

    function update() {
      const st = getFindingState(finding.id)
      adoptBtn.setAttribute('aria-pressed', String(st.decision === 'adopted'))
      rejectBtn.setAttribute('aria-pressed', String(st.decision === 'rejected'))
      holdBtn.setAttribute('aria-pressed', String(!st.decision))
      card.dataset.decision = st.decision || 'pending'
      if (document.activeElement !== textarea && textarea.value !== (st.comment || '')) {
        textarea.value = st.comment || ''
      }
    }
    registerFindingInstance(finding.id, update)
    update()

    return card
  }

  // ---------- Section: header ----------
  let headerProgressEl = null

  function updateHeaderProgress() {
    if (!headerProgressEl) return
    const approvable = reportData.groups.filter((g) => !g.isUnclassified)
    const approvedCount = approvable.filter(
      (g) => state.groups[g.id] && state.groups[g.id].approved,
    ).length
    headerProgressEl.textContent = '承認 ' + approvedCount + '/' + approvable.length
  }

  function renderHeader() {
    const stats = reportData.meta.stats
    const statsText = stats
      ? stats.files +
        ' files / ' +
        stats.hunks +
        ' hunks +' +
        stats.insertions +
        ' -' +
        stats.deletions
      : ''

    const header = h('header', { id: 'site-header' })
    header.appendChild(h('span', { class: 'header-label', text: 'DIFF REVIEW' }))
    header.appendChild(h('span', { class: 'header-title', text: reportData.meta.title }))
    header.appendChild(h('span', { class: 'header-stats', text: statsText }))
    headerProgressEl = h('span', { class: 'header-progress' })
    header.appendChild(headerProgressEl)
    header.appendChild(
      h('button', {
        type: 'button',
        class: 'help-btn',
        text: '?',
        'aria-label': 'ヘルプ',
        onClick: () => toggleHelp(true),
      }),
    )
    document.getElementById('app').appendChild(header)
    updateHeaderProgress()
  }

  // ---------- Section 01: overview ----------
  function scrollToGroup(id) {
    const el = document.getElementById('group-' + id)
    if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' })
  }

  function renderSection01(main) {
    const section = h('section', { id: 'section-01' })
    section.appendChild(h('div', { class: 'section-heading', text: '01 / 概要' }))
    const card = h('div', { class: 'card' })

    if (reportData.summary) {
      card.appendChild(h('p', { class: 'overview-summary', text: reportData.summary }))
    }

    const meta = h('div', { class: 'overview-meta' })
    meta.appendChild(
      h('span', { class: 'pill', text: 'base: ' + (reportData.meta.base || '(unknown)') }),
    )
    meta.appendChild(
      h('span', {
        class: 'pill',
        text: reportData.meta.planPath ? 'plan: ' + reportData.meta.planPath : 'plan: なし',
      }),
    )
    card.appendChild(meta)

    const stageNote = h('p', {
      class: 'stage-note',
      text: '1段階目のレビューは plan ファイルを一切開示せずに行われています（忖度防止）。2段階目で plan と突き合わせ、指摘の要否を再判定しています。',
    })
    card.appendChild(stageNote)

    const list = h('div', { class: 'group-list' })
    for (const group of reportData.groups) {
      const row = h('button', {
        type: 'button',
        class: 'group-row risk-' + group.risk,
        onClick: () => scrollToGroup(group.id),
      })
      row.appendChild(h('span', { class: 'group-row-title', text: group.title }))
      row.appendChild(
        h('span', {
          class: 'group-row-desc',
          text: group.unclear ? '(意図が読み取れません)' : group.intent,
        }),
      )
      row.appendChild(h('span', { class: 'badge', text: '指摘 ' + group.findings.length }))
      row.appendChild(h('span', { class: 'tag', text: group.category }))
      row.appendChild(h('span', { class: 'tag', text: 'hunk ' + group.hunks.length }))
      row.appendChild(
        h('span', {
          class: 'badge risk-' + group.risk,
          text: RISK_LABEL[group.risk] || group.risk,
        }),
      )
      list.appendChild(row)
    }
    card.appendChild(list)

    section.appendChild(card)
    main.appendChild(section)
  }

  // ---------- Section 02: group cards ----------
  function renderSection02(main) {
    const section = h('section', { id: 'section-02' })
    section.appendChild(h('div', { class: 'section-heading', text: '02 / 変更グループ詳細' }))
    const wrap = h('div', { class: 'group-cards' })

    for (const group of reportData.groups) {
      const card = h('div', {
        class:
          'card group-card risk-' + group.risk + (group.isUnclassified ? ' is-unclassified' : ''),
        id: 'group-' + group.id,
      })

      const headRow = h('div', { class: 'group-card-head' })
      const left = h('div', { class: 'group-card-head-left' })
      left.appendChild(
        h('span', {
          class: 'badge risk-' + group.risk,
          text: RISK_LABEL[group.risk] || group.risk,
        }),
      )
      left.appendChild(h('span', { class: 'group-card-title', text: group.title }))
      left.appendChild(h('span', { class: 'tag', text: group.category }))
      headRow.appendChild(left)

      if (!group.isUnclassified) {
        const approveLabel = h('label', { class: 'approve-toggle' })
        const approveCb = h('input', { type: 'checkbox' })
        approveCb.checked = !!(state.groups[group.id] && state.groups[group.id].approved)
        approveCb.addEventListener('change', () => setGroupApproved(group.id, approveCb.checked))
        approveLabel.appendChild(approveCb)
        approveLabel.appendChild(document.createTextNode('確認して承認'))
        headRow.appendChild(approveLabel)
      }
      card.appendChild(headRow)

      if (group.unclear) {
        card.appendChild(
          h('div', { class: 'unclear-banner', text: '要改善: 意図が読み取れません' }),
        )
      } else {
        const intentP = h('p', { class: 'group-intent' })
        intentP.appendChild(h('span', { class: 'label', text: '意図:' }))
        intentP.appendChild(document.createTextNode(group.intent))
        card.appendChild(intentP)
      }
      if (group.detail) {
        card.appendChild(h('p', { class: 'group-detail', text: group.detail }))
      }

      for (const hunk of group.hunks) {
        card.appendChild(renderHunk(hunk))
        for (const finding of hunk.findings) {
          card.appendChild(renderFindingCard(finding))
        }
      }

      wrap.appendChild(card)
    }

    section.appendChild(wrap)
    main.appendChild(section)
  }

  // ---------- Section 03: plan check ----------
  function renderSection03(main) {
    if (
      !reportData.planCheck ||
      !Array.isArray(reportData.planCheck.items) ||
      reportData.planCheck.items.length === 0
    ) {
      return
    }
    const section = h('section', { id: 'section-03' })
    section.appendChild(h('div', { class: 'section-heading', text: '03 / plan 照合' }))
    const card = h('div', { class: 'card' })

    const table = h('table', { class: 'plan-check' })
    const thead = h(
      'thead',
      {},
      h('tr', {}, [
        h('th', { text: 'plan項目' }),
        h('th', { text: '状態' }),
        h('th', { text: '根拠' }),
      ]),
    )
    table.appendChild(thead)
    const tbody = h('tbody')
    for (const item of reportData.planCheck.items) {
      const tr = h('tr')
      tr.appendChild(h('td', { text: item.planItem }))
      tr.appendChild(
        h(
          'td',
          {},
          h('span', {
            class: 'plan-status status-' + item.status,
            text: PLAN_STATUS_LABEL[item.status] || item.status,
          }),
        ),
      )
      tr.appendChild(h('td', { text: item.note || '' }))
      tbody.appendChild(tr)
    }
    table.appendChild(tbody)
    card.appendChild(table)

    section.appendChild(card)
    main.appendChild(section)
  }

  // ---------- Section 04: flat findings list ----------
  let focusableFindings = []
  let currentFocusIndex = -1

  function renderSection04(main) {
    const section = h('section', { id: 'section-04' })
    section.appendChild(h('div', { class: 'section-heading', text: '04 / 指摘一覧' }))
    const card = h('div', { class: 'card' })

    const filters = h('div', { class: 'filters' })

    const severitySelect = h('select', { 'aria-label': 'severityで絞り込む' })
    severitySelect.appendChild(h('option', { value: 'all', text: 'すべての重要度' }))
    for (const sev of ['blocker', 'warning', 'note']) {
      severitySelect.appendChild(h('option', { value: sev, text: SEVERITY_LABEL[sev] }))
    }
    const severityLabel = h('label', { text: '重要度: ' }, severitySelect)

    const decisionSelect = h('select', { 'aria-label': '採否で絞り込む' })
    decisionSelect.appendChild(h('option', { value: 'all', text: 'すべての採否' }))
    decisionSelect.appendChild(h('option', { value: 'adopted', text: '採用' }))
    decisionSelect.appendChild(h('option', { value: 'rejected', text: '却下' }))
    decisionSelect.appendChild(h('option', { value: 'pending', text: '未判定' }))
    const decisionLabel = h('label', { text: '採否: ' }, decisionSelect)

    const groupSelect = h('select', { 'aria-label': 'グループで絞り込む' })
    groupSelect.appendChild(h('option', { value: 'all', text: 'すべてのグループ' }))
    for (const group of reportData.groups) {
      if (group.findings.length === 0) continue
      groupSelect.appendChild(h('option', { value: group.id, text: group.title }))
    }
    const groupLabel = h('label', { text: 'グループ: ' }, groupSelect)

    filters.appendChild(severityLabel)
    filters.appendChild(decisionLabel)
    filters.appendChild(groupLabel)
    card.appendChild(filters)

    const list = h('div', { class: 'findings-flat-list' })
    card.appendChild(list)

    function decisionOf(finding) {
      const st = getFindingState(finding.id)
      return st.decision || 'pending'
    }

    function renderList() {
      list.textContent = ''
      focusableFindings = []
      const sevFilter = severitySelect.value
      const decFilter = decisionSelect.value
      const groupFilter = groupSelect.value

      const filtered = allFindings
        .filter((f) => sevFilter === 'all' || f.severity === sevFilter)
        .filter((f) => decFilter === 'all' || decisionOf(f) === decFilter)
        .filter((f) => groupFilter === 'all' || f.groupId === groupFilter)
        .slice()
        .sort((a, b) => SEVERITY_ORDER[a.severity] - SEVERITY_ORDER[b.severity])

      if (filtered.length === 0) {
        list.appendChild(
          h('p', { class: 'finding-body', text: '条件に一致する指摘はありません。' }),
        )
        return
      }

      for (const finding of filtered) {
        const wrap = h('div')
        wrap.appendChild(h('div', { class: 'finding-group-tag', text: finding.groupTitle }))
        const card2 = renderFindingCard(finding)
        wrap.appendChild(card2)
        list.appendChild(wrap)
        focusableFindings.push({ id: finding.id, cardEl: card2 })
      }
      currentFocusIndex = -1
    }

    severitySelect.addEventListener('change', renderList)
    decisionSelect.addEventListener('change', renderList)
    groupSelect.addEventListener('change', renderList)
    renderList()

    section.appendChild(card)
    main.appendChild(section)
  }

  // ---------- Section 05: feedback assembly ----------
  let countEls = {}
  let feedbackPreviewEl = null
  let feedbackStatusEl = null
  let globalCommentEl = null

  function updateSection05Counts() {
    let adopted = 0
    let rejected = 0
    let pending = 0
    let commented = 0
    for (const finding of allFindings) {
      const st = getFindingState(finding.id)
      if (st.decision === 'adopted') adopted++
      else if (st.decision === 'rejected') rejected++
      else pending++
      if (st.comment && st.comment.trim()) commented++
    }
    if (countEls.adopted) countEls.adopted.textContent = '採用 ' + adopted
    if (countEls.rejected) countEls.rejected.textContent = '却下 ' + rejected
    if (countEls.pending) countEls.pending.textContent = '未判定 ' + pending
    if (countEls.commented) countEls.commented.textContent = 'コメント ' + commented
  }

  function buildFeedbackMarkdown() {
    const adopted = []
    const rejected = []
    for (const finding of allFindings) {
      const st = getFindingState(finding.id)
      if (st.decision === 'adopted') adopted.push(finding)
      else if (st.decision === 'rejected') rejected.push(finding)
    }

    let md = '# レビューフィードバック\n\n'
    md += '## 依頼\n\n'
    md += '- 以下の指摘が忖度なしで妥当かどうか精査してください。妥当でないものは指摘してください\n'
    md += '- 対応方針に迷う点があれば、実装前に確認してください。\n\n'

    adopted.forEach((finding, idx) => {
      const label = SEVERITY_LABEL[finding.severity] || finding.severity
      md += '### ' + (idx + 1) + '. [' + label + '] ' + finding.title + '\n\n'
      md += '- 場所: ' + finding.location + ' [' + finding.hunk + ']\n'
      const group = reportData.groups.find((g) => g.id === finding.groupId)
      md += '- 変更グループの意図: ' + (group ? group.intent || '(意図不明)' : '(意図不明)') + '\n'
      if (finding.planNote) {
        md += '- 備考: ' + finding.planNote + '\n'
      }
      md += '- 指摘: ' + finding.body + '\n'
      md += '- 改善案: ' + finding.suggestion + '\n'
      const st = getFindingState(finding.id)
      const comment = st.comment && st.comment.trim()
      if (comment) {
        md += '- 人間コメント: ' + comment + '\n'
      }
      md += '\n'
    })

    const globalComment = (state.globalComment || '').trim()
    if (globalComment) {
      md += '## 追加コメント\n\n' + globalComment + '\n\n'
    }

    if (rejected.length > 0) {
      md += '## 却下した指摘（対応不要）\n\n'
      for (const finding of rejected) {
        md += '- ' + finding.title + '\n'
      }
      md += '\n'
    }

    return md.replace(/\n+$/, '\n')
  }

  async function copyToClipboard(text) {
    if (navigator.clipboard && navigator.clipboard.writeText) {
      try {
        await navigator.clipboard.writeText(text)
        return true
      } catch (e) {
        // fall through to legacy fallback
      }
    }
    try {
      const ta = document.createElement('textarea')
      ta.value = text
      ta.style.position = 'fixed'
      ta.style.opacity = '0'
      document.body.appendChild(ta)
      ta.focus()
      ta.select()
      const ok = document.execCommand('copy')
      document.body.removeChild(ta)
      if (ok) return true
    } catch (e) {
      // ignore, fall through to manual-copy prompt below
    }
    return false
  }

  function generateFeedback() {
    const md = buildFeedbackMarkdown()
    feedbackPreviewEl.textContent = md
    feedbackStatusEl.textContent = '生成しました。「クリップボードにコピー」を押してください。'
    return md
  }

  function renderSection05(main) {
    const section = h('section', { id: 'section-05' })
    section.appendChild(h('div', { class: 'section-heading', text: '05 / フィードバック組み立て' }))
    const card = h('div', { class: 'card' })

    const counts = h('div', { class: 'feedback-counts' })
    countEls.adopted = h('span', { class: 'badge' })
    countEls.rejected = h('span', { class: 'badge' })
    countEls.pending = h('span', { class: 'badge' })
    countEls.commented = h('span', { class: 'badge' })
    counts.appendChild(countEls.adopted)
    counts.appendChild(countEls.rejected)
    counts.appendChild(countEls.pending)
    counts.appendChild(countEls.commented)
    card.appendChild(counts)

    card.appendChild(
      h('p', {
        text: '採用された指摘と追加コメントを、元の作業エージェントに渡す markdown にまとめます。',
      }),
    )

    globalCommentEl = h('textarea', {
      class: 'global-comment',
      placeholder: '全体コメント（任意）',
    })
    globalCommentEl.value = state.globalComment || ''
    globalCommentEl.addEventListener('input', () => {
      state.globalComment = globalCommentEl.value
      saveState()
    })
    card.appendChild(globalCommentEl)

    const actions = h('div', { class: 'feedback-actions' })
    const generateBtn = h('button', {
      type: 'button',
      class: 'btn btn-primary',
      text: 'フィードバックを生成',
    })
    const copyBtn = h('button', { type: 'button', class: 'btn', text: 'クリップボードにコピー' })
    feedbackStatusEl = h('span', { class: 'feedback-status' })
    actions.appendChild(generateBtn)
    actions.appendChild(copyBtn)
    actions.appendChild(feedbackStatusEl)
    card.appendChild(actions)

    feedbackPreviewEl = h('pre', { id: 'feedback-preview' })
    card.appendChild(feedbackPreviewEl)

    generateBtn.addEventListener('click', generateFeedback)
    copyBtn.addEventListener('click', async () => {
      const md = feedbackPreviewEl.textContent || generateFeedback()
      const ok = await copyToClipboard(md)
      if (ok) {
        feedbackStatusEl.textContent = 'クリップボードにコピーしました。'
      } else {
        feedbackStatusEl.textContent = 'コピーに失敗しました。手動で選択してコピーしてください。'
        const range = document.createRange()
        range.selectNodeContents(feedbackPreviewEl)
        const sel = window.getSelection()
        sel.removeAllRanges()
        sel.addRange(range)
      }
    })

    const resetRow = h('div', { class: 'reset-row' })
    const resetBtn = h('button', {
      type: 'button',
      class: 'btn btn-danger-outline',
      text: '状態をリセット',
      onClick: () => {
        if (
          window.confirm(
            '保存された採否・コメント・承認状態をすべてリセットします。よろしいですか？',
          )
        ) {
          try {
            localStorage.removeItem(storageKey)
          } catch (e) {
            // ignore
          }
          state = defaultState()
          for (const finding of allFindings) syncFindingUI(finding.id)
          for (const group of reportData.groups) {
            const cb = document.querySelector('#group-' + group.id + ' .approve-toggle input')
            if (cb) cb.checked = false
          }
          globalCommentEl.value = ''
          feedbackPreviewEl.textContent = ''
          feedbackStatusEl.textContent = 'リセットしました。'
          updateHeaderProgress()
          updateSection05Counts()
        }
      },
    })
    resetRow.appendChild(resetBtn)
    card.appendChild(resetRow)

    section.appendChild(card)
    main.appendChild(section)
    updateSection05Counts()
  }

  // ---------- Help modal ----------
  let helpModalEl = null

  function toggleHelp(show) {
    if (!helpModalEl) return
    if (show === undefined) show = helpModalEl.hasAttribute('hidden')
    if (show) helpModalEl.removeAttribute('hidden')
    else helpModalEl.setAttribute('hidden', '')
  }

  function renderHelpModal() {
    const shortcuts = [
      ['j / k', '指摘間を移動'],
      ['a', '現在の指摘を採用'],
      ['r', '現在の指摘を却下'],
      ['c', 'コメント欄にフォーカス'],
      ['g', 'フィードバックを生成'],
      ['?', 'このヘルプを開閉'],
    ]
    const modal = h('div', { id: 'help-modal', hidden: '' })
    const cardEl = h('div', { class: 'modal-card' })
    cardEl.appendChild(h('h2', { text: 'キーボードショートカット' }))
    const dl = h('dl')
    for (const [key, desc] of shortcuts) {
      dl.appendChild(h('dt', { text: key }))
      dl.appendChild(h('dd', { text: desc }))
    }
    cardEl.appendChild(dl)
    cardEl.appendChild(
      h('button', {
        type: 'button',
        class: 'btn',
        text: '閉じる',
        onClick: () => toggleHelp(false),
      }),
    )
    modal.appendChild(cardEl)
    modal.addEventListener('click', (e) => {
      if (e.target === modal) toggleHelp(false)
    })
    document.getElementById('app').appendChild(modal)
    helpModalEl = modal
  }

  // ---------- Keyboard shortcuts ----------
  function moveFocus(delta) {
    if (focusableFindings.length === 0) return
    if (currentFocusIndex >= 0 && focusableFindings[currentFocusIndex]) {
      focusableFindings[currentFocusIndex].cardEl.classList.remove('current-focus')
    }
    currentFocusIndex = Math.min(
      Math.max(currentFocusIndex + delta, 0),
      focusableFindings.length - 1,
    )
    const entry = focusableFindings[currentFocusIndex]
    entry.cardEl.classList.add('current-focus')
    entry.cardEl.scrollIntoView({ behavior: 'smooth', block: 'center' })
  }

  function currentFindingId() {
    if (currentFocusIndex < 0 || !focusableFindings[currentFocusIndex]) return null
    return focusableFindings[currentFocusIndex].id
  }

  function bindGlobalKeyboardShortcuts() {
    document.addEventListener('keydown', (e) => {
      const tag = document.activeElement && document.activeElement.tagName
      const typing = tag === 'TEXTAREA' || tag === 'INPUT' || tag === 'SELECT'
      if (typing) {
        if (e.key === 'Escape') document.activeElement.blur()
        return
      }
      switch (e.key) {
        case 'j':
          moveFocus(1)
          break
        case 'k':
          moveFocus(-1)
          break
        case 'a': {
          const id = currentFindingId()
          if (id) setDecision(id, 'adopted')
          break
        }
        case 'r': {
          const id = currentFindingId()
          if (id) setDecision(id, 'rejected')
          break
        }
        case 'c': {
          const entry = focusableFindings[currentFocusIndex]
          if (entry && entry.cardEl._commentTextarea) entry.cardEl._commentTextarea.focus()
          break
        }
        case 'g':
          generateFeedback()
          document.getElementById('section-05').scrollIntoView({ behavior: 'smooth' })
          break
        case '?':
          toggleHelp()
          break
        case 'Escape':
          toggleHelp(false)
          break
        default:
          break
      }
    })
  }

  // ---------- Bootstrap ----------
  function init() {
    const app = document.getElementById('app')
    renderHeader()
    const main = h('main')
    app.appendChild(main)
    renderSection01(main)
    renderSection02(main)
    renderSection03(main)
    renderSection04(main)
    renderSection05(main)
    renderHelpModal()
    bindGlobalKeyboardShortcuts()
  }

  init()
})()
