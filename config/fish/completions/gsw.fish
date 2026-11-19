complete -c gsw -f -n '__fish_is_first_token' \
    -a '(git for-each-ref --format="%(refname:lstrip=2)" refs/heads 2>/dev/null)'
complete -c gsw -f -s h -l help -d 'Show usage'
