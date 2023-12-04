if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path ~/bin

# aqua
set -xg AQUA_ROOT_DIR $HOME/.local/share/aquaproj-aqua
fish_add_path $AQUA_ROOT_DIR/bin

# volta
set -xg VOLTA_HOME $HOME/.volta
fish_add_path $VOLTA_HOME/bin


# -------------------------
# Alias
# -------------------------
alias cls clear

alias tree 'tree -a -I "\.DS_Store|\.git|node_modules|dist|vendor\/bundle" -N'
