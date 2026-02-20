function bit --description 'AI-powered git workflow (commit / branch / pr / review / stash / explain / conflict)'
    if test (count $argv) -eq 0
        echo "Usage: bit <command>"
        echo "  commit            コミットメッセージをAIが生成"
        echo "  branch [issue]    ブランチ名をAIが生成 (issue番号省略可)"
        echo "  pr                PRをAIが生成して作成"
        echo "  review            AIがコードレビュー"
        echo "  stash             意味のある名前でstash"
        echo "  explain [commit]  コミットをAIが日本語解説 (省略時はHEAD)"
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
            __bit_stash
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
# 共通ヘルパー: Claudeの出力からInsightブロックや
# マークダウン装飾を除いた最初の1行を抽出する
# ──────────────────────────────────────────────
function __bit_extract_oneliner
    # Pass 1: Conventional Commits パターンを優先検索
    for line in $argv
        set -l clean (string replace -ra '`' '' -- $line | string trim)
        if string match -rq '^(feat|fix|chore|docs|style|refactor|test|build|ci|perf|revert)(\([^)]*\))?!?: ' -- $clean
            echo $clean
            return
        end
    end
    # Pass 2: 構造的マークダウン行を除いた最初の意味ある行
    for line in $argv
        set -l clean (string replace -ra '`' '' -- $line | string trim)
        if test -z "$clean"; continue; end
        if string match -rq '^[★─#]' -- $clean; continue; end  # insight/header
        if string match -rq '^[-*] ' -- $clean; continue; end   # bullet point
        echo $clean
        return
    end
end

# ──────────────────────────────────────────────
# commit: staged優先 → 未stageなら案内してからcommit
# ──────────────────────────────────────────────
function __bit_commit
    set -l diff_staged (git diff --cached)
    set -l diff_all (git diff)

    if test -z "$diff_staged" -a -z "$diff_all"
        echo "❌ 変更がありません"
        return 1
    end

    # ステージ済みがない場合はステージ操作を促す
    if test -z "$diff_staged"
        echo "⚠️  ステージされた変更がありません。現在の変更:"
        echo ""
        git status --short
        echo ""
        read -l -P "[a]全てstage (git add -A) / [p]対話的に選択 (git add -p) / [n]キャンセル > " stage_choice
        switch $stage_choice
            case a A
                git add -A
            case p P
                git add -p
            case '*'
                echo "キャンセルしました"
                return 0
        end
        set diff_staged (git diff --cached)
        if test -z "$diff_staged"
            echo "何もstageされませんでした"
            return 1
        end
    end

    echo "🤖 コミットメッセージを生成中..."
    set -l raw (echo $diff_staged | claude -p \
        "このgit diffを分析し、Conventional Commits形式でコミットメッセージを1行提案してください。"\
        "出力はコミットメッセージ文字列のみ。バッククォート・コードブロック・説明文は一切含めないこと。"\
        "例: feat(auth): add JWT token validation")

    set -l msg (__bit_extract_oneliner $raw | string trim)

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
    if test (count $argv) -gt 0
        set -l issue_num $argv[1]
        echo "🤖 Issue #$issue_num からブランチ名を生成中..."

        set -l issue_json (gh issue view $issue_num --json title,body 2>/dev/null)
        if test -z "$issue_json"
            echo "❌ Issue #$issue_num が見つかりません"
            return 1
        end

        set -l raw (echo $issue_json | claude -p \
            "以下のGitHub issueのJSONからGitブランチ名を生成してください。"\
            "形式: $issue_num-<kebab-case>（例: $issue_num-add-user-auth）。"\
            "ブランチ名のみ出力してください。バッククォート・説明文は不要。")
        set -l branch_name (__bit_extract_oneliner $raw | string trim)
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
        set -l raw (echo $diff | claude -p \
            "このgit diffからGitブランチ名を提案してください。"\
            "形式: <type>/<kebab-case>（例: feat/add-user-auth）。"\
            "ブランチ名のみ出力してください。バッククォート・説明文は不要。")
        set -l branch_name (__bit_extract_oneliner $raw | string trim)
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

    echo "🤖 PRを生成中..."
    # 出力形式: 1行目=タイトル、2行目=空行、3行目以降=本文
    # → fish のリスト分割で $content[1] / $content[3..] に自然に分かれる
    set -l content (printf "## Commits\n%s\n\n## Diff\n%s" \
        (string join \n $log) \
        (string join \n $diff) \
        | claude -p \
        "以下のコミット一覧とdiffからGitHub PRのタイトルと本文を生成してください。"\
        "出力形式: 1行目にPRタイトル（prefix・バッククォート不要）、2行目は空行、3行目以降にマークダウン形式の本文。"\
        "Insight・説明文はタイトル行に含めないこと。")

    if test -z "$content"
        echo "❌ 生成に失敗しました"
        return 1
    end

    # タイトル行もInsightが混入しうるので extract_oneliner で取り出す
    set -l title (__bit_extract_oneliner $content[1] | string trim)
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

    echo "🤖 コードレビュー中..."
    echo ""
    echo $diff | claude -p \
        "このgit diffに対してコードレビューを行ってください。"\
        "バグ・セキュリティリスク・パフォーマンス・可読性の観点で指摘してください。"\
        "問題がなければ「LGTM」と理由を述べてください。"
end

# ──────────────────────────────────────────────
# stash: diffから意味のある名前を生成してstash
# ──────────────────────────────────────────────
function __bit_stash
    set -l diff (git diff HEAD)
    if test -z "$diff"
        set diff (git diff)
    end
    if test -z "$diff"
        echo "❌ stashする変更がありません"
        return 1
    end

    echo "🤖 stash名を生成中..."
    set -l raw (echo $diff | claude -p \
        "このgit diffを分析し、stashの内容を表す短い説明を英語で生成してください。"\
        "kebab-caseで30文字以内。名前のみ出力してください。バッククォート・説明文は不要。"\
        "例: wip-refactor-auth-flow")
    set -l name (__bit_extract_oneliner $raw | string trim)

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

# ──────────────────────────────────────────────
# explain: コミットの内容をAIが日本語解説
#          引数なし → HEAD
# ──────────────────────────────────────────────
function __bit_explain
    set -l commit HEAD
    if test (count $argv) -gt 0
        set commit $argv[1]
    end

    set -l stat (git show --stat $commit 2>/dev/null)
    if test -z "$stat"
        echo "❌ コミット '$commit' が見つかりません"
        return 1
    end

    echo "🤖 コミットを解説中... ($commit)"
    echo ""
    printf "## Stat\n%s\n\n## Diff\n" (string join \n $stat)
    git show $commit \
        | claude -p \
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

        # tempファイルに解決済みコードを書き出す
        # (fishのコマンド置換は改行でリスト分割するため直接リダイレクトが安全)
        set -l tmp (mktemp)
        cat $file | claude -p \
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
