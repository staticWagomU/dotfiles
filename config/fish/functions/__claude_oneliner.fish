# Claude の Explanatory スタイル出力から最初の意味ある1行を抽出する共通ヘルパー
# bit / cmd / sman / what など claude -p を使う関数から共有する
function __claude_oneliner
    # Pass 1: Conventional Commits パターンを優先検索 (bit commit 向け)
    for line in $argv
        set -l clean (string replace -ra '`' '' -- $line | string trim)
        if string match -rq '^(feat|fix|chore|docs|style|refactor|test|build|ci|perf|revert)(\([^)]*\))?!?: ' -- $clean
            echo $clean
            return
        end
    end
    # Pass 2: 構造的マークダウン / Insight行を除いた最初の意味ある行
    for line in $argv
        set -l clean (string replace -ra '`' '' -- $line | string trim)
        if test -z "$clean"; continue; end
        if string match -rq '^[★─#]' -- $clean; continue; end  # Insight / header
        if string match -rq '^[-*] ' -- $clean; continue; end   # bullet
        echo $clean
        return
    end
end
