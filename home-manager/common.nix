{
  config,
  pkgs,
  inputs,
  username,
  hostname,
  system,
  ...
}:

let
  nodePkgs = pkgs.callPackage ../node2nix { inherit pkgs; };
in
{
  home.username = username;
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";

  home.packages = with pkgs; [
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
    delta
    # aider-chat  # temporarily disabled due to texlive-bin-big-2025 build failure on macOS
    peco
    yt-dlp

    nodePkgs."@anthropic-ai/claude-code"
    nodePkgs."@google/gemini-cli"

    # font
    hackgen-nf-font
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # programs.fish = {
  #   enable = true;
  #   plugins = [
  #     {
  #       name = "bass";
  #       src = pkgs.fishPlugins.bass.src;
  #     }
  #   ];
  # };

  home.stateVersion = "24.05";
}
