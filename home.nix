{ config, pkgs, inputs, username, hostname, system, ... }:

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

    pkgs.neovim-nightly
    pkgs.emacs
    pkgs.vim
  ];


  home.stateVersion = "24.05";
}
