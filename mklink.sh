if [ -d "../.config/nvim" ]
then
  mkdir ~/.config/nvim
else
  rm -rf ~/.config/nvim
  mkdir ~/.config/nvim
fi

ln -s ./nvim/init.lua ../.config/nvim/init.lua
ln -s ./nvim/lua ../.config/nvim/lua
ln -s ./nvim/after ../.config/nvim/after


if [ -d "../.config/wezterm" ]
then
  mkdir  ~/.config/wezterm
else
  rm -rf ~/.config/wezterm
  mkdir ~/.config/wezterm
fi

ln -s ./wezterm.lua ../.config/wezterm/wezterm.lua
