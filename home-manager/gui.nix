{
  config,
  pkgs,
  inputs,
  username,
  hostname,
  system,
  ...
}:

{
  imports = [
    ./wezterm
    ./shells
  ];

  home.packages = [
    pkgs.alacritty
    pkgs.wezterm
    inputs.arto.packages.${system}.default
  ];

  home.file.".config/alacritty/alacritty.toml".text = ''
    [general]
    import = [
      "${config.home.homeDirectory}/dotfiles/config/alacritty/base.toml",
      "${config.home.homeDirectory}/dotfiles/config/alacritty/colorscheme/catppuccin-macchiato.toml",
    ]

    [terminal.shell]
    program = "${pkgs.nushell}/bin/nu"
    args = ["--login", "--interactive"]
  '';

  home.sessionVariables = {
    SHELL = "${pkgs.fish}/bin/fish";
  };
}
