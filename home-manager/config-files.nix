{ config, lib, ... }:

let
  dotfilesDir = "${config.home.homeDirectory}/dotfiles";
  # Link individual files so Fish/plugin-generated files can coexist.
  fishFiles =
    directory:
    lib.mapAttrs' (
      name: _:
      lib.nameValuePair "fish/${directory}/${name}" {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/fish/${directory}/${name}";
      }
    ) (builtins.readDir (../config/fish + "/${directory}"));
in
{
  xdg.configFile = {
    # Fixed configuration: edits take effect after rebuild and are versioned by Nix.
    "tmux/tmux.conf".source = ../config/tmux/tmux.conf;
    "ghostty/config".source = ../config/ghostty/config;
    "zellij/config.kdl".source = ../config/zellij/config.kdl;
    "helix/config.toml".source = ../config/helix/config.toml;
    "lazygit/config.yml".source = ../config/lazygit/config.yml;
    "nix/nix.conf".source = ../config/nix/nix.conf;

    # Leave Yazi's directory writable for plugins and generated state.
    "yazi/yazi.toml".source = ../config/yazi/yazi.toml;
    "yazi/keymap.toml".source = ../config/yazi/keymap.toml;
    "yazi/theme.toml".source = ../config/yazi/theme.toml;
    "yazi/flavors/kaku-dark.yazi/flavor.toml".source =
      ../config/yazi/flavors/kaku-dark.yazi/flavor.toml;
    "yazi/flavors/kaku-light.yazi/flavor.toml".source =
      ../config/yazi/flavors/kaku-light.yazi/flavor.toml;

    # Keep local Herdr edits live until they have been reconciled with the repo.
    "herdr/config.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/herdr/config.toml";
  }
  // fishFiles "functions"
  // fishFiles "completions";
}
