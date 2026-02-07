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
  home.sessionVariables = {
    SHELL = "${pkgs.fish}/bin/fish";
  };

  # macOS specific CLI tools (migrated from Homebrew)
  home.packages = with pkgs; [
    # Modern CLI utilities
    eza # Modern replacement for ls
    lnav # Log file navigator
    tmux # Terminal multiplexer
    tree # Directory tree viewer
    zellij # Modern terminal workspace

    # Database tools
    duckdb # Analytical database

    # Development tools
    terminal-notifier # macOS notifications from CLI
  ];
}
