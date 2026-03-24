# Tab completion for claude-mode

# Subcommands (only when no subcommand given yet)
set -l subcmds bedrock br sub subscription api status s

complete -c claude-mode -f -n "not __fish_seen_subcommand_from $subcmds" \
    -a bedrock  -d 'Bedrock mode (private data)'
complete -c claude-mode -f -n "not __fish_seen_subcommand_from $subcmds" \
    -a br       -d 'Bedrock mode (short)'
complete -c claude-mode -f -n "not __fish_seen_subcommand_from $subcmds" \
    -a sub      -d 'Subscription mode'
complete -c claude-mode -f -n "not __fish_seen_subcommand_from $subcmds" \
    -a status   -d 'Show current mode'

# AWS profiles for bedrock subcommand
function __claude_mode_aws_profiles
    awk '/^\[profile / { gsub(/\[profile |\]/, ""); print } /^\[default\]/ { print "default" }' ~/.aws/config 2>/dev/null
end

# AWS profiles (2nd arg: right after bedrock/br)
function __claude_mode_needs_profile
    set -l cmd (commandline -opc)
    test (count $cmd) -eq 2
    and contains -- $cmd[2] bedrock br
end

complete -c claude-mode -f -n __claude_mode_needs_profile \
    -a '(__claude_mode_aws_profiles)' -d 'AWS Profile'

# AWS Bedrock regions (3rd arg: after profile)
function __claude_mode_needs_region
    set -l cmd (commandline -opc)
    test (count $cmd) -eq 3
    and contains -- $cmd[2] bedrock br
end

complete -c claude-mode -f -n __claude_mode_needs_region \
    -a 'us-east-1 us-west-2 ap-northeast-1 eu-west-1' -d 'AWS Region'
