{ config, pkgs, inputs, username, hostname, system, ... }:

{
  home.username = username;
  # ホームディレクトリはOSによって異なるため、ここで設定
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";

  # --- 共通パッケージ ---
  home.packages = [
    pkgs.git
    pkgs.htop
    pkgs.ripgrep
    pkgs.gh
    pkgs.neovim
    pkgs.emacs
    pkgs.vim
    pkgs.fish
    pkgs.home-manager
  ];

  fonts.fontconfig.enable = true;
  home.packages = home.packages ++ [
    pkgs.hackgen-nf-font
  ];



  programs.fish.enable = true; # Fish自体は共通で有効化

  home.stateVersion = "24.05";
}
