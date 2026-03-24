function claude-mode -d "Switch Claude Code between Subscription and Bedrock"
    switch "$argv[1]"
        case bedrock br
            set -gx CLAUDE_CODE_USE_BEDROCK 1
            if test -n "$argv[2]"
                set -gx AWS_PROFILE $argv[2]
            end
            if test -n "$argv[3]"
                set -gx AWS_REGION $argv[3]
            end
            echo "Claude Code: Bedrock mode (AWS_PROFILE=$(set -q AWS_PROFILE && echo $AWS_PROFILE || echo 'default'), AWS_REGION=$(set -q AWS_REGION && echo $AWS_REGION || echo 'not set'))"

        case sub subscription api
            set -e CLAUDE_CODE_USE_BEDROCK
            echo "Claude Code: Subscription mode"

        case status s ''
            if set -q CLAUDE_CODE_USE_BEDROCK
                echo "Claude Code: Bedrock mode (AWS_PROFILE=$(set -q AWS_PROFILE && echo $AWS_PROFILE || echo 'default'), AWS_REGION=$(set -q AWS_REGION && echo $AWS_REGION || echo 'not set'))"
            else
                echo "Claude Code: Subscription mode"
            end

        case '*'
            echo "Usage: claude-mode <command> [aws-profile] [aws-region]"
            echo ""
            echo "Commands:"
            echo "  bedrock, br          Switch to Bedrock (private data)"
            echo "  sub, subscription    Switch to Subscription (default)"
            echo "  status, s            Show current mode"
            echo ""
            echo "Examples:"
            echo "  claude-mode bedrock"
            echo "  claude-mode bedrock my-profile ap-northeast-1"
            echo "  claude-mode sub"
    end
end
