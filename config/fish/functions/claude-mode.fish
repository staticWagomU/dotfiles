function claude-mode -d "Switch Claude Code between Subscription, Bedrock, Z.AI, and Qwen"
    # Anthropic 互換プロバイダ用の変数をまとめて落とす。
    # プロバイダごとに設定する変数の数が違うため、切り替え時は必ず全消ししてから設定する。
    function __claude_mode_clear_provider
        set -e ANTHROPIC_AUTH_TOKEN
        set -e ANTHROPIC_BASE_URL
        set -e API_TIMEOUT_MS
        set -e ANTHROPIC_DEFAULT_HAIKU_MODEL
        set -e ANTHROPIC_DEFAULT_SONNET_MODEL
        set -e ANTHROPIC_DEFAULT_OPUS_MODEL
        set -e CLAUDE_CODE_SUBAGENT_MODEL
        set -e CLAUDE_CODE_MAX_CONTEXT_TOKENS
    end

    # API キーは dotfiles に置かず Keychain から取る
    function __claude_mode_keychain -a service
        set -l token (security find-generic-password -a "$USER" -s "$service" -w 2>/dev/null)
        if test -z "$token"
            echo "Error: API key not found in Keychain (service: $service)" >&2
            echo "Run: security add-generic-password -a \"\$USER\" -s \"$service\" -w \"YOUR_API_KEY\"" >&2
            return 1
        end
        echo $token
    end

    function __claude_mode_status
        if set -q CLAUDE_CODE_USE_BEDROCK
            echo "Claude Code: Bedrock mode (AWS_PROFILE=$(set -q AWS_PROFILE && echo $AWS_PROFILE || echo 'default'), AWS_REGION=$(set -q AWS_REGION && echo $AWS_REGION || echo 'not set'))"
        else if set -q ANTHROPIC_BASE_URL; and string match -q '*z.ai*' $ANTHROPIC_BASE_URL
            echo "Claude Code: Z.AI mode (OPUS=$ANTHROPIC_DEFAULT_OPUS_MODEL, SONNET=$ANTHROPIC_DEFAULT_SONNET_MODEL, HAIKU=$ANTHROPIC_DEFAULT_HAIKU_MODEL)"
        else if set -q ANTHROPIC_BASE_URL; and string match -q '*aliyuncs.com*' $ANTHROPIC_BASE_URL
            echo "Claude Code: Qwen mode (OPUS=$ANTHROPIC_DEFAULT_OPUS_MODEL, SONNET=$ANTHROPIC_DEFAULT_SONNET_MODEL, HAIKU=$ANTHROPIC_DEFAULT_HAIKU_MODEL, SUBAGENT=$CLAUDE_CODE_SUBAGENT_MODEL)"
        else
            echo "Claude Code: Subscription mode"
        end
    end

    switch "$argv[1]"
        case bedrock br
            __claude_mode_clear_provider
            set -gx CLAUDE_CODE_USE_BEDROCK 1
            if test -n "$argv[2]"
                set -gx AWS_PROFILE $argv[2]
            end
            if test -n "$argv[3]"
                set -gx AWS_REGION $argv[3]
            end
            __claude_mode_status

        case zai z
            set -l token (__claude_mode_keychain zai-api-key); or return 1
            set -e CLAUDE_CODE_USE_BEDROCK
            __claude_mode_clear_provider
            set -gx ANTHROPIC_AUTH_TOKEN $token
            set -gx ANTHROPIC_BASE_URL https://api.z.ai/api/anthropic
            set -gx API_TIMEOUT_MS 3000000
            set -gx ANTHROPIC_DEFAULT_HAIKU_MODEL glm-4.7-FlashX
            set -gx ANTHROPIC_DEFAULT_SONNET_MODEL glm-4.7
            set -gx ANTHROPIC_DEFAULT_OPUS_MODEL glm-4.7
            __claude_mode_status

        case qwen q
            set -l token (__claude_mode_keychain qwen-api-key); or return 1
            set -e CLAUDE_CODE_USE_BEDROCK
            __claude_mode_clear_provider
            set -gx ANTHROPIC_AUTH_TOKEN $token
            # Token Plan のエンドポイント。末尾は /apps/anthropic で、/v1 を付けてはいけない
            set -gx ANTHROPIC_BASE_URL https://token-plan.ap-southeast-1.maas.aliyuncs.com/apps/anthropic
            set -gx API_TIMEOUT_MS 3000000
            set -gx ANTHROPIC_DEFAULT_HAIKU_MODEL qwen3.6-flash
            set -gx ANTHROPIC_DEFAULT_SONNET_MODEL qwen3.8-max-preview
            set -gx ANTHROPIC_DEFAULT_OPUS_MODEL qwen3.8-max-preview
            set -gx CLAUDE_CODE_SUBAGENT_MODEL qwen3.7-max
            set -gx CLAUDE_CODE_MAX_CONTEXT_TOKENS 983616
            __claude_mode_status

        case sub subscription api
            set -e CLAUDE_CODE_USE_BEDROCK
            __claude_mode_clear_provider
            __claude_mode_status

        case status s ''
            __claude_mode_status

        case '*'
            echo "Usage: claude-mode <command> [aws-profile] [aws-region]"
            echo ""
            echo "Commands:"
            echo "  bedrock, br          Switch to Bedrock (private data)"
            echo "  zai, z               Switch to Z.AI (GLM models)"
            echo "  qwen, q              Switch to Qwen Cloud (Token Plan)"
            echo "  sub, subscription    Switch to Subscription (default)"
            echo "  status, s            Show current mode"
            echo ""
            echo "Examples:"
            echo "  claude-mode bedrock"
            echo "  claude-mode bedrock my-profile ap-northeast-1"
            echo "  claude-mode zai"
            echo "  claude-mode qwen"
            echo "  claude-mode sub"
    end
end
