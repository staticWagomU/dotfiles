del %USERPROFILE%\wezterm.lua
mklink %USERPROFILE%\wezterm.lua %USERPROFILE%\dotfiles\config\wezterm\wezterm.lua
del %USERPROFILE%\.wezterm.lua
mklink %USERPROFILE%\.wezterm.lua %USERPROFILE%\dotfiles\config\wezterm\wezterm.lua

del %USERPROFILE%\.tigrc
mklink %USERPROFILE%\.tigrc %USERPROFILE%\dotfiles\config\.tigrc

del %USERPROFILE%\.gitconfig
mklink %USERPROFILE%\.gitconfig %USERPROFILE%\dotfiles\config\.gitconfig

del %USERPROFILE%\aqua.yaml
mklink %USERPROFILE%\aqua.yaml %USERPROFILE%\dotfiles\config\aqua.yaml
