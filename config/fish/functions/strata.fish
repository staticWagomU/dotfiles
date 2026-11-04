function strata --description 'ローカルLLM Strata (Q2_0) を http://127.0.0.1:8080 で起動'
    # Nixのcc/SDKがXcodeのSDKと衝突するため、Apple標準ツールを先頭に置く
    set -l dir ~/dev/strata-try/src
    if not test -x $dir/run-q2_0.sh
        echo "❌ $dir/run-q2_0.sh がありません"
        return 1
    end
    cd $dir; and env PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH" ./run-q2_0.sh $argv
end
