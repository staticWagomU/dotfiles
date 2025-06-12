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
    pkgs.ghq
    pkgs.neovim
    pkgs.emacs
    pkgs.vim
    pkgs.fish
    pkgs.home-manager
    pkgs.nodejs_20
    pkgs.claude-code

    # font
    pkgs.hackgen-nf-font
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };


  home.stateVersion = "24.05";
}
