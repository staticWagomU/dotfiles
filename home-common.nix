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
  ];


  programs.fish.enable = true; # Fish自体は共通で有効化

  home.stateVersion = "24.05";
}
