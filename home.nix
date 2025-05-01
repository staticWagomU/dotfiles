{ config, pkgs, ... }:

{
  home.username = "wagomu";
  home.homeDirectory = "/Users/wagomu";

  home.packages = [
    pkgs.git
#     pkgs.vim
    pkgs.htop
    pkgs.ripgrep
    pkgs.gh
    pkgs.wezterm

    pkgs.neovim-nightly-overlay
    pkgs.emacs-overlay
    pkgs.vim-overlay
  ];


  home.stateVersion = "24.05";
}
