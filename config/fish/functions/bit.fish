function bit --description 'AI-powered git workflow (commit / branch / pr / review / stash / explain / conflict)'
    if test (count $argv) -eq 0
        echo "Usage: bit <command>"
        echo "  commit            コミットメッセージをAIが生成"
        echo "  branch [issue]    ブランチ名をAIが生成 (issue番号省略可)"
        echo "  pr                PRをAIが生成して作成"
        echo "  review            AIがコードレビュー"
        echo "  stash [pop]       AI命名でstash / fzfでpop"
        echo "  explain [commit]  コミットをAIが日本語解説 (省略時はfzfで選択)"
        echo "  conflict          コンフリクトをAIが解決提案"
        return 0
    end

    switch $argv[1]
        case commit
            __bit_commit
        case branch
            __bit_branch $argv[2..]
        case pr
            __bit_pr
        case review
            __bit_review
        case stash
            __bit_stash $argv[2..]
        case explain
            __bit_explain $argv[2..]
        case conflict
            __bit_conflict
        case '*'
            echo "Unknown command: $argv[1]"
            bit
            return 1
    end
end

# ──────────────────────────────────────────────
# commit: fzfでファイルを選択してstage → AIがメッセージ生成
# ──────────────────────────────────────────────
function __bit_commit
    # 現在のstaging状態を取得
    set -l staged_files (git diff --cached --name-only 2>/dev/null)
    set -l modified_files (git diff --name-only 2>/dev/null)
    set -l untracked_files (git ls-files --others --exclude-standard 2>/dev/null)

    # プレフィックス "X " (2文字) でステータスを可視化
    #   + = staged / ~ = modified(unstaged) / ? = untracked
    set -l items
    for f in $staged_files
        set -a items "+ $f"
    end
    for f in $modified_files
        # staged と unstaged 両方ある場合は staged 側のみに表示
        if not contains -- $f $staged_files
            set -a items "~ $f"
        end
    end
    for f in $untracked_files
        set -a items "? $f"
    end

    if test -z "$items"
        echo "❌ 変更がありません"
        return 1
    end

    # fzfでstageしたいファイルをトグル選択
    # + のファイルは「既にstaged」の意味だが fzf に pre-selection はないため
    # ユーザーが最終的にstageしたいファイルを選ぶ UI とする
    set -l selected (string join \n $items | fzf --multi \
        --prompt "stage> " \
        --header "+:staged  ~:modified  ?:untracked  |  TAB:toggle  Enter:apply" \
        --preview 'f=$(echo {} | cut -c3-); git diff HEAD -- "$f" 2>/dev/null; cat "$f" 2>/dev/null' \
        --preview-window 'right:60%:wrap')

    if test -z "$selected"
        echo "キャンセルしました"
        return 0
    end

    # プレフィックス "X " を除いてファイル名を取得
    set -l files_to_stage
    for line in $selected
        set -a files_to_stage (string sub -s 3 -- $line)
    end

    # staged済みだが今回選ばなかったものを unstage
    for f in $staged_files
        if not contains -- $f $files_to_stage
            git restore --staged -- $f
        end
    end

    # 選択ファイルを stage
    for f in $files_to_stage
        git add -- $f
    end

    set -l diff_staged (git diff --cached)
    if test -z "$diff_staged"
        echo "何もstageされませんでした"
        return 1
    end

    set -l flags --model haiku --tools "" --no-session-persistence \
        --system-prompt "Output only the exact text requested. No markdown, no backticks, no code blocks, no explanations."

    echo "🤖 コミットメッセージを生成中..."
    set -l raw (echo $diff_staged | claude -p $flags \
        "このgit diffを分析し、Conventional Commits形式でコミットメッセージを1行提案してください。"\
        "例: feat(auth): add JWT token validation")

    set -l msg (__claude_oneliner $raw | string trim)

    if test -z "$msg"
        echo "❌ 生成に失敗しました"
        return 1
    end

    echo ""
    echo "📝 提案: $msg"
    echo ""
    read -l -P "[y]コミット / [n]キャンセル / [e]編集 > " choice

    switch $choice
        case '' y Y
            git commit -m "$msg"
        case e E
            read -l -P "✏️  メッセージ: " edited
            if test -n "$edited"
                git commit -m "$edited"
            end
        case '*'
            echo "キャンセルしました"
    end
end

# ──────────────────────────────────────────────
# branch: issue番号あり → ghでissue取得
#         省略         → diffから推測
# ──────────────────────────────────────────────
function __bit_branch
    set -l flags --model haiku --tools "" --no-session-persistence \
        --system-prompt "Output only the exact text requested. No markdown, no backticks, no code blocks, no explanations."

    if test (count $argv) -gt 0
        set -l issue_num $argv[1]
        echo "🤖 Issue #$issue_num からブランチ名を生成中..."

        set -l issue_json (gh issue view $issue_num --json title,body 2>/dev/null)
        if test -z "$issue_json"
            echo "❌ Issue #$issue_num が見つかりません"
            return 1
        end

        set -l raw (echo $issue_json | claude -p $flags \
            "以下のGitHub issueのJSONからGitブランチ名を生成してください。"\
            "形式: $issue_num-<kebab-case>（例: $issue_num-add-user-auth）。ブランチ名のみ出力。")
        set -l branch_name (__claude_oneliner $raw | string trim)
    else
        set -l diff (git diff HEAD 2>/dev/null)
        if test -z "$diff"
            set diff (git diff)
        end
        if test -z "$diff"
            echo "❌ 変更がありません"
            return 1
        end

        echo "🤖 変更内容からブランチ名を生成中..."
        set -l raw (echo $diff | claude -p $flags \
            "このgit diffからGitブランチ名を提案してください。"\
            "形式: <type>/<kebab-case>（例: feat/add-user-auth）。ブランチ名のみ出力。")
        set -l branch_name (__claude_oneliner $raw | string trim)
    end

    if test -z "$branch_name"
        echo "❌ 生成に失敗しました"
        return 1
    end

    echo ""
    echo "🌿 提案: $branch_name"
    echo ""
    read -l -P "[y]作成&チェックアウト / [n]キャンセル / [e]編集 > " choice

    switch $choice
        case '' y Y
            git checkout -b $branch_name
        case e E
            read -l -P "✏️  ブランチ名: " edited
            if test -n "$edited"
                git checkout -b $edited
            end
        case '*'
            echo "キャンセルしました"
    end
end

# ──────────────────────────────────────────────
# pr: デフォルトブランチとのdiff + commit logでPR生成
# ──────────────────────────────────────────────
function __bit_pr
    set -l default_branch (git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | string replace 'refs/remotes/origin/' '')
    if test -z "$default_branch"
        set default_branch main
    end

    set -l log (git log $default_branch..HEAD --oneline 2>/dev/null)
    if test -z "$log"
        echo "❌ $default_branch との差分コミットが見つかりません"
        return 1
    end

    set -l diff (git diff $default_branch...HEAD 2>/dev/null)
    set -l flags --model haiku --tools "" --no-session-persistence

    echo "🤖 PRを生成中..."
    set -l content (printf "## Commits\n%s\n\n## Diff\n%s" \
        (string join \n $log) \
        (string join \n $diff) \
        | claude -p $flags \
        "以下のコミット一覧とdiffからGitHub PRのタイトルと本文を生成してください。"\
        "出力形式: 1行目にPRタイトルのみ、2行目は空行、3行目以降にマークダウン形式の本文。")

    if test -z "$content"
        echo "❌ 生成に失敗しました"
        return 1
    end

    set -l title (__claude_oneliner $content[1] | string trim)
    set -l body (string join \n $content[3..])

    echo ""
    echo "📋 タイトル: $title"
    echo ""
    echo "📄 本文:"
    echo $body
    echo ""
    read -l -P "[y]PR作成 / [n]キャンセル > " choice

    switch $choice
        case '' y Y
            gh pr create --title "$title" --body "$body"
        case '*'
            echo "キャンセルしました"
    end
end

# ──────────────────────────────────────────────
# review: 現在の変更をAIがレビュー
# ──────────────────────────────────────────────
function __bit_review
    set -l diff (git diff --cached)
    if test -z "$diff"
        set diff (git diff)
    end
    if test -z "$diff"
        echo "❌ 変更がありません"
        return 1
    end

    set -l flags --model haiku --tools "" --no-session-persistence

    echo "🤖 コードレビュー中..."
    echo ""
    echo $diff | claude -p $flags \
        "このgit diffに対してコードレビューを行ってください。"\
        "バグ・セキュリティリスク・パフォーマンス・可読性の観点で指摘してください。"\
        "問題がなければ「LGTM」と理由を述べてください。"
end

# ──────────────────────────────────────────────
# stash:
#   bit stash     → AI命名でpush
#   bit stash pop → fzfでstash選択してpop / Ctrl-Aでapply
# ──────────────────────────────────────────────
function __bit_stash
    if test (count $argv) -gt 0 -a "$argv[1]" = pop
        __bit_stash_pop
        return
    end

    set -l diff (git diff HEAD)
    if test -z "$diff"
        set diff (git diff)
    end
    if test -z "$diff"
        echo "❌ stashする変更がありません"
        return 1
    end

    set -l flags --model haiku --tools "" --no-session-persistence \
        --system-prompt "Output only the exact text requested. No markdown, no backticks, no code blocks, no explanations."

    echo "🤖 stash名を生成中..."
    set -l raw (echo $diff | claude -p $flags \
        "このgit diffを分析し、stashの内容を表す短い説明を英語で生成してください。"\
        "kebab-caseで30文字以内。名前のみ出力。例: wip-refactor-auth-flow")
    set -l name (__claude_oneliner $raw | string trim)

    if test -z "$name"
        echo "❌ 生成に失敗しました"
        return 1
    end

    echo ""
    echo "📦 提案: $name"
    echo ""
    read -l -P "[y]stash / [n]キャンセル / [e]編集 > " choice

    switch $choice
        case '' y Y
            git stash push -m "$name"
        case e E
            read -l -P "✏️  stash名: " edited
            if test -n "$edited"
                git stash push -m "$edited"
            end
        case '*'
            echo "キャンセルしました"
    end
end

function __bit_stash_pop
    set -l list (git stash list)
    if test -z "$list"
        echo "❌ stashがありません"
        return 1
    end

    # --expect で Enter(pop) と Ctrl-A(apply) を分岐
    set -l result (string join \n $list | fzf \
        --prompt "stash> " \
        --expect 'ctrl-a' \
        --header "Enter: pop (削除) / Ctrl-A: apply (残す)" \
        --preview 'ref=$(echo {} | cut -d: -f1); git stash show -p "$ref"' \
        --preview-window 'right:60%:wrap')

    if test -z "$result"
        echo "キャンセルしました"
        return 0
    end

    # fzf --expect の出力: 1行目=押されたキー / 2行目以降=選択行
    set -l key $result[1]
    set -l line $result[2]
    # "stash@{N}: ..." から "stash@{N}" を取得
    set -l ref (string split ':' -- $line)[1]

    if test -z "$ref"
        echo "❌ stash参照の取得に失敗しました"
        return 1
    end

    if test "$key" = ctrl-a
        git stash apply $ref
        echo "✅ apply: $line（stashは残っています）"
    else
        git stash pop $ref
    end
end

# ──────────────────────────────────────────────
# explain: 引数なし → fzfでコミット選択
#          引数あり → そのコミットを解説
# ──────────────────────────────────────────────
function __bit_explain
    set -l commit

    if test (count $argv) -gt 0
        set commit $argv[1]
    else
        # git log をfzfで選択 (--stat をpreviewに表示)
        set -l selected (git log --oneline --no-decorate -50 2>/dev/null | fzf \
            --prompt "explain> " \
            --header "解説するコミットを選択" \
            --preview 'git show --stat {1}' \
            --preview-window 'right:60%:wrap')

        if test -z "$selected"
            echo "キャンセルしました"
            return 0
        end

        set commit (string split ' ' -- $selected)[1]
    end

    set -l stat (git show --stat $commit 2>/dev/null)
    if test -z "$stat"
        echo "❌ コミット '$commit' が見つかりません"
        return 1
    end

    set -l flags --model haiku --tools "" --no-session-persistence

    echo "🤖 コミットを解説中... ($commit)"
    echo ""
    printf "## Stat\n%s\n\n## Diff\n" (string join \n $stat)
    git show $commit \
        | claude -p $flags \
        "以下のgitコミット情報（stat + diff）を日本語でわかりやすく解説してください。"\
        "変更の目的・影響範囲・技術的なポイントを簡潔にまとめてください。"
end

# ──────────────────────────────────────────────
# conflict: コンフリクトファイルをAIが解決提案
#           tempファイル経由でファイルI/Oを安全に処理
# ──────────────────────────────────────────────
function __bit_conflict
    set -l conflicted (git diff --name-only --diff-filter=U 2>/dev/null)
    if test -z "$conflicted"
        echo "❌ コンフリクトしているファイルがありません"
        return 1
    end

    set -l flags --model haiku --tools "" --no-session-persistence \
        --system-prompt "Output only the resolved code. No conflict markers, no explanations, no markdown code fences."

    echo "⚠️  コンフリクトファイル:"
    for f in $conflicted
        echo "  $f"
    end
    echo ""

    for file in $conflicted
        echo "────────────────────────────────────────"
        echo "📄 $file"
        echo "────────────────────────────────────────"
        echo "🤖 解決策を生成中..."

        set -l tmp (mktemp)
        cat $file | claude -p $flags \
            "以下のgitコンフリクトマーカー（<<<<<<<、=======、>>>>>>>）を含むファイルを解析し、"\
            "両方の変更を適切にマージした解決済みのコードを出力してください。"\
            "マーカーは一切含めず、解決済みのファイル全体を出力してください。" > $tmp

        echo ""
        cat $tmp
        echo ""
        read -l -P "[y]この内容で上書き & stage / [n]スキップ > " choice

        if test "$choice" = y -o "$choice" = Y -o -z "$choice"
            cp $tmp $file
            git add $file
            echo "✅ $file を解決してstageしました"
        else
            echo "スキップしました"
        end

        rm -f $tmp
        echo ""
    end

    set -l remaining (git diff --name-only --diff-filter=U 2>/dev/null)
    if test -z "$remaining"
        echo "🎉 全コンフリクトが解決されました"
        echo "次のステップ: git commit でマージを完了させてください"
    end
end
