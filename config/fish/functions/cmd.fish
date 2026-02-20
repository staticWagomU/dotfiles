function cmd --description '自然言語からシェルコマンドを生成して実行'
    if test (count $argv) -eq 0
        echo "Usage: cmd <やりたいことを自然言語で>"
        echo "例:  cmd 最近3日間で変更されたTSファイルをサイズ順に表示"
        return 1
    end

    set -l description (string join ' ' $argv)
    set -l flags --model haiku --tools "" --no-session-persistence \
        --system-prompt "Output only the exact shell command requested. No markdown, no backticks, no code blocks, no explanations."

    echo "🤖 コマンドを生成中..."
    set -l raw (echo $description | claude -p $flags \
        "以下の説明からfishシェルのコマンドを1行で生成してください。OS: macOS (darwin)。"\
        "例: find . -name '*.ts' -mtime -3 -exec ls -lS {} +")

    set -l command (__claude_oneliner $raw | string trim)

    if test -z "$command"
        echo "❌ 生成に失敗しました"
        return 1
    end

    echo ""
    echo "  "(set_color yellow)$command(set_color normal)
    echo ""
    read -l -P "[y]実行 / [n]キャンセル / [e]編集 > " choice

    switch $choice
        case '' y Y
            eval $command
        case e E
            read -l -P "✏️  コマンド: " edited
            if test -n "$edited"
                eval $edited
            end
        case '*'
            echo "キャンセルしました"
    end
end
