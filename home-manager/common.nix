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
    tokei
    zoxide
    fd
    yq
    tailscale
    pik

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

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
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

  # tmux config as symlink
  # シンボリックリンクにすることで、dotfiles の変更が即座に反映される
  xdg.configFile."tmux/tmux.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/tmux/tmux.conf";

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotvim/nvim";
  };

  xdg.configFile."nvim-kawaii" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotvim/nvim-kawaii";
  };

  xdg.configFile."nvim-sub" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotvim/nvim-sub";
  };

  xdg.configFile."vim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotvim/vim";
  };

  # Git config as a copy (not symlink)
  # home.file.".gitconfig".text = builtins.readFile ../config/.gitconfig_other;

  # Claude Code config (individual files, not the whole directory)
  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/claude/CLAUDE.md";
  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/claude/settings.json";
  home.file.".claude/statusline.sh".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/claude/statusline.sh";
  home.file.".claude/agents".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/claude/agents";
  home.file.".claude/commands".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/claude/commands";
  home.file.".claude/rules".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/claude/rules";
  home.file.".claude/scripts".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/claude/scripts";
  home.file.".claude/skills".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/claude/skills";

  # Git config initialization (copy if not exists, not symlink)
  # This allows gh auth login and other tools to write to ~/.gitconfig
  home.activation.gitconfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f ~/.gitconfig ]; then
      cat > ~/.gitconfig << 'EOF'
# vi:syntax=.gitconfig:
[include]
  path = ~/dotfiles/config/.gitconfig
[ghq]
  root = ~/dev
[commit]
  template = ~/dotfiles/config/.gitmessage
EOF
      echo "Created ~/.gitconfig with include directive"
    fi
  '';

  home.stateVersion = "24.05";
}
