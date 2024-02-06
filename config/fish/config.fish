if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path ~/bin

# deno
set -xg DENO_INSTALL /home/wagomu/.deno
fish_add_path $DENO_INSTALL/bin

# aqua
set -xg AQUA_ROOT_DIR $HOME/.local/share/aquaproj-aqua
fish_add_path $AQUA_ROOT_DIR/bin

# volta
set -xg VOLTA_HOME $HOME/.volta
fish_add_path $VOLTA_HOME/bin

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
