function what --description 'カレントプロジェクトをAIが日本語で解説'
    set -l context ""

    set -l meta_files \
        README.md README.rst README.txt \
        package.json Cargo.toml go.mod pyproject.toml \
        build.gradle pom.xml flake.nix

    for file in $meta_files
        if test -f $file
            set context $context\n\n"## $file"\n(head -80 $file)
        end
    end

    if git rev-parse --git-dir >/dev/null 2>&1
        set -l tree (git ls-files 2>/dev/null | head -40)
        if test -n "$tree"
            set context $context\n\n"## tracked files (top 40)"\n(string join \n $tree)
        end

        set -l log (git log --oneline -8 2>/dev/null)
        if test -n "$log"
            set context $context\n\n"## recent commits"\n(string join \n $log)
        end
    end

    if test -z "$context"
        echo "❌ プロジェクトファイルが見つかりません"
        return 1
    end

    set -l flags --model haiku --tools "" --no-session-persistence

    echo "🤖 プロジェクトを解析中..."
    echo ""
    echo $context | claude -p $flags \
        "以下のプロジェクトファイル群を分析して日本語で解説してください。"\
        "## 概要 / ## 技術スタック / ## 主要な機能 / ## 開発状況"\
        "の4セクションで簡潔にまとめてください。"
end
