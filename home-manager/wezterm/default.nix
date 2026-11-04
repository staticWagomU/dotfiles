{ config, ... }:

let
  dotfilesDir = "${config.home.homeDirectory}/dotfiles";
in
{
  # Keep terminal configuration and its local plugin editable without rebuilding.
  xdg.configFile = {
    "wezterm/wezterm.lua".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/wezterm/wezterm.lua";
    "wezterm/pane-manager.wezterm".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/wezterm/pane-manager.wezterm";
  };
}
