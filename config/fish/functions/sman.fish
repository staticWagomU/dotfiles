function sman --description 'AI版manページ – 日本語で概要・主要オプション・使用例を解説'
    if test (count $argv) -eq 0
        echo "Usage: sman <command>"
        return 1
    end

    set -l target $argv[1]
    set -l man_text (PAGER=cat man $target 2>/dev/null | col -bx)

    if test -z "$man_text"
        echo "❌ '$target' のmanページが見つかりません"
        echo "💡 --help を試みます..."
        set man_text ($target --help 2>&1)
        if test -z "$man_text"
            return 1
        end
    end

    set -l flags --model haiku --tools "" --no-session-persistence

    echo "📖 $target を解説中..."
    echo ""
    string join \n $man_text | claude -p $flags \
        "このmanページ / helpテキストを日本語でわかりやすく解説してください。"\
        "以下の構成でまとめてください:"\
        "## 概要  → 何をするコマンドか1-2文"\
        "## よく使うオプション  → 実用的なものTop 6-8を表形式で"\
        "## 使用例  → コピペして使えるコマンド例を3-5個 (コメント付き)"
end
