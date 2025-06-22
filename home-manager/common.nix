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
    aider-chat
    peco

    # nodePkgs."@anthropic-ai/claude-code"

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
