# bit コマンドのfish補完

# ──────────────────────────────────────────────
# 動的補完ヘルパー
# ──────────────────────────────────────────────

# GitHub open issueを "番号[TAB]タイトル" 形式で返す
function __bit_gh_issues
    gh issue list --json number,title \
        --jq '.[] | (.number | tostring) + " " + .title' 2>/dev/null \
        | string replace -r '^(\d+) (.*)' '$1\t$2'
end

# git logを "ハッシュ[TAB]メッセージ" 形式で返す
function __bit_git_commits
    git log --oneline --no-decorate 2>/dev/null \
        | string replace -r '^(\S+) (.*)' '$1\t$2'
end

# ──────────────────────────────────────────────
# サブコマンド補完 (サブコマンドがまだ入力されていない場合)
# ──────────────────────────────────────────────
set -l subcmds commit branch pr review stash explain conflict

complete -c bit -f -n "not __fish_seen_subcommand_from $subcmds" \
    -a commit   -d 'コミットメッセージをAIが生成'
complete -c bit -f -n "not __fish_seen_subcommand_from $subcmds" \
    -a branch   -d 'ブランチ名をAIが生成 (issue番号省略可)'
complete -c bit -f -n "not __fish_seen_subcommand_from $subcmds" \
    -a pr       -d 'PRをAIが生成して作成'
complete -c bit -f -n "not __fish_seen_subcommand_from $subcmds" \
    -a review   -d 'AIがコードレビュー'
complete -c bit -f -n "not __fish_seen_subcommand_from $subcmds" \
    -a stash    -d '意味のある名前でstash'
complete -c bit -f -n "not __fish_seen_subcommand_from $subcmds" \
    -a explain  -d 'コミットをAIが日本語解説 (省略時はHEAD)'
complete -c bit -f -n "not __fish_seen_subcommand_from $subcmds" \
    -a conflict -d 'コンフリクトをAIが解決提案'

# ──────────────────────────────────────────────
# 引数補完 (サブコマンド別)
# ──────────────────────────────────────────────

# branch: GitHub issueを補完
complete -c bit -f -n '__fish_seen_subcommand_from branch' \
    -a '(__bit_gh_issues)' \
    -d 'Issue番号'

# explain: gitコミットを補完
complete -c bit -f -n '__fish_seen_subcommand_from explain' \
    -a '(__bit_git_commits)'
