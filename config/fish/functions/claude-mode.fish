function claude-mode -d "Switch Claude Code between Subscription, Bedrock, and Z.AI"
    function __claude_mode_clear_zai
        set -e ANTHROPIC_AUTH_TOKEN
        set -e ANTHROPIC_BASE_URL
        set -e API_TIMEOUT_MS
        set -e ANTHROPIC_DEFAULT_HAIKU_MODEL
        set -e ANTHROPIC_DEFAULT_SONNET_MODEL
        set -e ANTHROPIC_DEFAULT_OPUS_MODEL
    end

    function __claude_mode_status
        if set -q CLAUDE_CODE_USE_BEDROCK
            echo "Claude Code: Bedrock mode (AWS_PROFILE=$(set -q AWS_PROFILE && echo $AWS_PROFILE || echo 'default'), AWS_REGION=$(set -q AWS_REGION && echo $AWS_REGION || echo 'not set'))"
        else if set -q ANTHROPIC_BASE_URL; and string match -q '*z.ai*' $ANTHROPIC_BASE_URL
            echo "Claude Code: Z.AI mode (OPUS=$ANTHROPIC_DEFAULT_OPUS_MODEL, SONNET=$ANTHROPIC_DEFAULT_SONNET_MODEL, HAIKU=$ANTHROPIC_DEFAULT_HAIKU_MODEL)"
        else
            echo "Claude Code: Subscription mode"
        end
    end

    switch "$argv[1]"
        case bedrock br
            __claude_mode_clear_zai
            set -gx CLAUDE_CODE_USE_BEDROCK 1
            if test -n "$argv[2]"
                set -gx AWS_PROFILE $argv[2]
            end
            if test -n "$argv[3]"
                set -gx AWS_REGION $argv[3]
            end
            __claude_mode_status

        case zai z
            set -e CLAUDE_CODE_USE_BEDROCK
            set -l token (security find-generic-password -a "$USER" -s "zai-api-key" -w 2>/dev/null)
            if test -z "$token"
                echo "Error: Z.AI API key not found in Keychain"
                echo "Run: security add-generic-password -a \"\$USER\" -s \"zai-api-key\" -w \"YOUR_API_KEY\""
                return 1
            end
            set -gx ANTHROPIC_AUTH_TOKEN $token
            set -gx ANTHROPIC_BASE_URL https://api.z.ai/api/anthropic
            set -gx API_TIMEOUT_MS 3000000
            set -gx ANTHROPIC_DEFAULT_HAIKU_MODEL glm-4.7-FlashX
            set -gx ANTHROPIC_DEFAULT_SONNET_MODEL glm-4.7
            set -gx ANTHROPIC_DEFAULT_OPUS_MODEL glm-5
            __claude_mode_status

        case sub subscription api
            set -e CLAUDE_CODE_USE_BEDROCK
            __claude_mode_clear_zai
            __claude_mode_status

        case status s ''
            __claude_mode_status

        case '*'
            echo "Usage: claude-mode <command> [aws-profile] [aws-region]"
            echo ""
            echo "Commands:"
            echo "  bedrock, br          Switch to Bedrock (private data)"
            echo "  zai, z               Switch to Z.AI (GLM models)"
            echo "  sub, subscription    Switch to Subscription (default)"
            echo "  status, s            Show current mode"
            echo ""
            echo "Examples:"
            echo "  claude-mode bedrock"
            echo "  claude-mode bedrock my-profile ap-northeast-1"
            echo "  claude-mode zai"
            echo "  claude-mode sub"
    end
end
