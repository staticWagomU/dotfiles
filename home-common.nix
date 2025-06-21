{ config, pkgs, inputs, username, hostname, system, ... }:

{
  home.username = username;
  # ホームディレクトリはOSによって異なるため、ここで設定
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";

  # --- 共通パッケージ ---
  home.packages =  with pkgs; [
    git
    htop
    ripgrep
    gh
    ghq
    neovim
    emacs
    vim
    fish
    home-manager
    nodejs_20
    unstable.claude-code
    aider-chat
    peco

    # font
    hackgen-nf-font
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "bass";
        src = pkgs.fishPlugins.bass.src;
      }
    ];
  };


  home.stateVersion = "24.05";
}
