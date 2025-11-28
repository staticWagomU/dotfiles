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
    lazygit

    # font
    hackgen-nf-font
    intel-one-mono

    devenv
    lftp
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
      {
        name = "fisher";
        src = inputs.fisher;
      }
    ];
    interactiveShellInit = builtins.readFile ../config/fish/config.fish;
  };

  # Fish functions as symlinks
  home.file.".config/fish/functions" = {
    source = ../config/fish/functions;
    recursive = true;
  };

  # zeno.zsh (fish) via declarative steps
  # 1) Provide ZENO_ROOT as an env var inside fish
  xdg.configFile."fish/conf.d/zeno-env.fish".text = ''
    set -gx ZENO_ROOT ${inputs.zeno-zsh}
  '';
  # 2) Symlink conf.d file from the repo
  xdg.configFile."fish/conf.d/zeno.fish".source = "${inputs.zeno-zsh}/shells/fish/conf.d/zeno.fish";

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotvim/nvim";
  };

  xdg.configFile."nvim-sub" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotvim/nvim-sub";
  };

  xdg.configFile."vim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotvim/vim";
  };

  # Git config as a copy (not symlink)
  home.file.".gitconfig".text = builtins.readFile ../config/.gitconfig_other;

  home.stateVersion = "24.05";
}
