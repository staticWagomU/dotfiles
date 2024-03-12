if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path ~/bin

# aqua
if set -q AQUA_ROOT_DIR
    set aqua_bin_dir $AQUA_ROOT_DIR/bin
else if set -q XDG_DATA_HOME
    set aqua_bin_dir $XDG_DATA_HOME/aquaproj-aqua/bin
else
    set aqua_bin_dir $HOME/.local/share/aquaproj-aqua/bin
end

set -gx PATH $aqua_bin_dir $PATH

set -gx BROUSER '"/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"'

# -------------------------
# Abbr
# -------------------------
abbr -a cls clear
abbr -a cp cp -i
abbr -a mc mv -i
abbr -a rm rm -i
abbr -a ll ls -al

abbr -a gs git status
abbr -a gb branch
abbr -a gd git diff

abbr -a n nvim
abbr -a n2 NVIM_APPNAME=nvim-sub nvim
abbr -a n3 NVIM_APPNAME=nvim-mini nvim


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

# proto
set -gx PROTO_HOME "$HOME/.proto"
set -gx PATH "$PROTO_HOME/shims:$PROTO_HOME/bin" $PATH
