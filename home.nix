{ config, pkgs, inputs, username, hostname, system, ... }:

{
  home.username = username;
  home.homeDirectory = "/Users/${username}";

  home.packages = [
    pkgs.emacs
    pkgs.fish
    pkgs.gh
    pkgs.git
    pkgs.htop
    pkgs.neovim
    pkgs.ripgrep
    pkgs.vim
    pkgs.wezterm
  ];

  programs.fish = {
    enable = true;

    environmentVariables = {
      EDITOR = "nvim";
    };
  };


  home.stateVersion = "24.05";
}
