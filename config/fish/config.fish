if status is-interactive
    # Commands to run in interactive sessions can go here
end

# -------------------------
# variables
# -------------------------

if test (uname -s) = "Darwin"
  set -l paths \
    /opt/homebrew/bin \
    /opt/homebrew/sbin \
    /usr/bin \
    /usr/sbin \
    /bin \
    /sbin \
    /usr/local/bin \
    /usr/local/sbin \
    /Library/Apple/usr/bin \

  for path in $paths
    if test -d $path
      and not contains $path $PATH
      fish_add_path $path
    end
  end
end


# deno
set -gx DENO_INSTALL "$HOME/.deno"
fish_add_path "$DENO_INSTALL/bin"

set -gx BROWSER '"/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"'
set -gx EDITOR nvim

fish_add_path ~/bin

fish_add_path ~/.rbenv/bin

# npm bin
fish_add_path ~/.npm-global/bin

# nix
fish_add_path /nix/var/nix/profiles/default/bin
fish_add_path ~/.nix-profile/bin

if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
end

if test -e ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    bass source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
end

if command -v direnv >/dev/null
    direnv hook fish | source
end


# -------------------------
# Abbr
# -------------------------
abbr -a cls clear
abbr -a cp cp -i
abbr -a mc mv -i
abbr -a rm rm -i
abbr -a ll ls -al

abbr -a gs git status
abbr -a gb git branch
abbr -a gd git diff
abbr -a gp git push
abbr -a gP git pull --autostash
abbr -a p 'cd (ghq list -p | peco --initial-filter Fuzzy)'

abbr -a d docker
abbr -a dc docker compose

abbr -a gg ghq get 

alias v='vim'
alias vi='vim'

alias n='nvim'
alias nn='NVIM_APPNAME=nvim-writing nvim'
alias n2='NVIM_APPNAME=nvim-sub nvim'
alias n3='NVIM_APPNAME=nvim-darkpowered nvim'
alias n4='NVIM_APPNAME=nvim-tmp nvim'
alias n5='NVIM_APPNAME=nvim-wagomu nvim'
alias ..='cd ..'
alias ...='cd ../..'


alias findn="find . \( -path '*/.git/*' -o -path '*/node_modules/*' -o -path '*/.next/*' -o -path '*/.vite/*' -o -path '*/.turbo/*' -o -path '*/tmp/*' -o -path '*/.pnpm-store/*' \) -prune -o -type f -print"

function peco_history
  history|peco --layout=bottom-up|read foo
  if [ $foo ]
    commandline $foo
  else
    commandline ''
  end
end

function fish_user_key_bindings
  bind \cr peco_history
end


set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_hide_untrackedfiles 1

set -g __fish_git_prompt_color_branch magenta
set -g __fish_git_prompt_showupstream "informative"
set -g __fish_git_prompt_char_upstream_ahead "↑ "
set -g __fish_git_prompt_char_upstream_behind "↓ "
set -g __fish_git_prompt_char_upstream_prefix ""

set -g __fish_git_prompt_char_stagedstate "● "
set -g __fish_git_prompt_char_dirtystate "✚ "
set -g __fish_git_prompt_char_untrackedfiles "… "
set -g __fish_git_prompt_char_conflictedstate "✖ "
set -g __fish_git_prompt_char_cleanstate "✔ "

set -g __fish_git_prompt_color_dirtystate blue
set -g __fish_git_prompt_color_stagedstate yellow
set -g __fish_git_prompt_color_invalidstate red
set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
set -g __fish_git_prompt_color_cleanstate green

# 各モードでデフォルトキーバインドを呼び出し
for mode in default insert visual
    fish_default_key_bindings -M $mode
end
fish_vi_key_bindings

# Added by `rbenv init` on Wed Jun  5 22:55:37 JST 2024
# status --is-interactive; and rbenv init - fish | source

# ref: https://github.com/mozumasu/dotfiles/blame/5c03a2a0d0a643dac52c20b19e6dd98662ab4614/.config/zsh/.zshrc#L111C1-L136C2
function create_gitignore
    set input_file $argv[1]

    # If the input is empty, set .gitignore to the default value.
    if test -z "$input_file"
        set input_file ".gitignore"
    end

    # Capture the selected templates from fzf
    set selected (gibo list | fzf \
        --multi \
        --preview "gibo dump {} | bat --style=numbers --color=always --paging=never")

    # If no selection was made, exit the function
    if test -z "$selected"
        echo "No templates selected. Exiting."
        return
    end

    # Dump the selected templates into the specified file
    echo "$selected" | xargs -n1 gibo dump >> "$input_file"

    # Display the resulting file with bat
    bat "$input_file"
end

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

if test (uname) = "Darwin"
  eval "$(/opt/homebrew/bin/brew shellenv)"
end

if test (uname) = "Darwin"
  # Added by OrbStack: command-line tools and integration
  # This won't be added again if you remove it.
  source ~/.orbstack/shell/init2.fish 2>/dev/null || :
end
