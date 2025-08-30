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
    delta
    # aider-chat  # temporarily disabled due to texlive-bin-big-2025 build failure on macOS
    peco
    fzf
    tree-sitter

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
    interactiveShellInit = builtins.readFile ../config/fish/config.fish;
  };

  # Fish functions as symlinks
  home.file.".config/fish/functions" = {
    source = ../config/fish/functions;
    recursive = true;
  };

  home.stateVersion = "24.05";
}
