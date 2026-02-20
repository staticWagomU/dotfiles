function err --description 'AIがエラーを解析して解決策を提案 (stdin or 引数)'
    set -l input

    if not isatty 0
        set input (cat)
    else if test (count $argv) -gt 0
        set input (string join ' ' $argv)
    else
        echo "Usage:"
        echo "  <command> 2>&1 | err    エラー出力をパイプして解析"
        echo "  err 'error message'     エラー文字列を直接渡して解析"
        return 1
    end

    set -l flags --model opus --tools "" --no-session-persistence

    echo "🔍 エラーを分析中..."
    echo ""
    string join \n $input | claude -p $flags \
        "以下のエラーを分析して日本語で説明してください。"\
        "【原因】【解決策】【予防策】の3セクションで簡潔にまとめてください。"
end
