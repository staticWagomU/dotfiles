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

# proto
set -gx PROTO_HOME "$HOME/.proto"
set -gx PROTO_INSTALL_DIR "$HOME/.proto/bin"
fish_add_path "$PROTO_HOME/bin"
fish_add_path "$PROTO_HOME/shims"

# aqua
if set -q AQUA_ROOT_DIR
    set -gx aqua_bin_dir $AQUA_ROOT_DIR/bin
else if set -q XDG_DATA_HOME
    set -gx aqua_bin_dir $XDG_DATA_HOME/aquaproj-aqua/bin
else
    set -gx aqua_bin_dir $HOME/.local/share/aquaproj-aqua/bin
end
fish_add_path $aqua_bin_dir

# mise
fish_add_path ~/.local/share/mise

set -gx BROWSER '"/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"'

fish_add_path ~/bin


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

alias n='nvim'
alias nn='NVIM_APPNAME=nvim-writing nvim'
alias n2='NVIM_APPNAME=nvim-sub nvim'
alias n3='NVIM_APPNAME=nvim-mini nvim'
alias n4='NVIM_APPNAME=nvim-tmp nvim'


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
