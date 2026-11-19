function gsw --description 'Switch branches or jump to their Git worktree'
    if contains -- --help $argv; or contains -- -h $argv
        printf '%s\n' 'Usage: gsw [branch]' \
            'Choose a local branch with fzf, or pass its name directly.' \
            'Jump to its worktree if checked out, otherwise switch branches here.'
        return 0
    end

    if test (count $argv) -gt 1
        printf '%s\n' 'Usage: gsw [branch]' >&2
        return 2
    end

    if test "$(git rev-parse --is-inside-work-tree 2>/dev/null)" != true
        printf '%s\n' 'gsw: run inside a Git working tree.' >&2
        return 1
    end

    set -l branch $argv[1]
    if not set -q branch[1]
        set -l branches (git for-each-ref --sort=-committerdate \
            --format='%(refname:lstrip=2)%09%(if)%(HEAD)%(then)current%(else)%(if)%(worktreepath)%(then)worktree%(else)switch here%(end)%(end)' refs/heads)
        or return 1

        if not set -q branches[1]
            printf '%s\n' 'gsw: no local branches found.' >&2
            return 1
        end

        set -l selected (printf '%s\n' $branches | fzf --no-multi --prompt='Branch> ' --delimiter=\t --nth=1)
        or return $status
        set branch (string split -f 1 \t -- "$selected")
    end

    set -l ref "refs/heads/$branch"
    if not git show-ref --verify --quiet -- "$ref"
        printf 'gsw: local branch not found: %s\n' "$branch" >&2
        return 1
    end

    if test "$(git symbolic-ref --quiet HEAD)" = "$ref"
        return 0
    end

    # The NUL keeps paths containing newlines intact. Git adds a newline after it.
    set -l worktree (git for-each-ref --format='%(worktreepath)%00' "$ref" | string split0)
    if test -n "$worktree[1]"
        builtin cd -- "$worktree[1]"
    else
        git switch --no-guess -- "$branch"
    end
end
