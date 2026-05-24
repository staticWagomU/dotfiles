{
  config,
  pkgs,
  inputs,
  username,
  hostname,
  ...
}:

{
  # Primary user (required for user-specific settings)
  system.primaryUser = username;

  # Disable nix-darwin's Nix management (using Determinate Nix)
  nix.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System-level packages (prefer home-manager for user packages)
  environment.systemPackages = with pkgs; [
    # Minimal system-level tools only
  ];

  # Tailscale service
  services.tailscale = {
    enable = true;
  };

  services.jankyborders = {
    enable = false;
    style = "round";
    width = 8.0;
    hidpi = true;
    ax_focus = true;
    active_color = "0xc0ff00f2";
    inactive_color = "0xff0080ff";
  };

  # Homebrew integration (for GUI apps not in nixpkgs)
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      cleanup = "uninstall"; # Remove unlisted packages but keep cache
    };

    taps = [
      "apple/apple"
      "atlassian/acli"
      "barutsrb/tap"
      "pakerwreah/calendr"
      "sst/tap"
      "steipete/tap"
      "yakitrak/yakitrak"
    ];

    brews = [
      # --- brew に残すもの（nixpkgs にない or brew が適切） ---
      "atlassian/acli/acli"
      # "ballerina"
      "beads"
      "cloud-sql-proxy"
      "colima"
      "curl" # システム curl との競合回避のため brew に残す
      "devcontainer"
      "docker"
      "docker-compose"
      "ekphos"
      "mysql"
      "opencode"
      "postgresql@16"
      # "volta" # mise と並走中のため一旦残す
      "yakitrak/yakitrak/obsidian-cli"
      # tailscale CLI is provided by nix-darwin services.tailscale

      # --- 以下は home-manager (mac.nix) に移行済み ---
      # duckdb, eza, gcc, lilypond, lnav, murex, ollama, openjdk@21,
      # portaudio, swiftformat, tbls, terminal-notifier, tmux, tree, zellij
    ];

    casks = [
      "1password"
      "aqua-voice"
      # "azookey"
      "bitwarden"
      "pakerwreah/calendr/calendr"
      "cleanshot"
      # "cyberduck"
      # "drawio"
      "dropbox"
      "gcloud-cli"
      "ghostty"
      "google-chrome"
      "iterm2"
      # "itsycal"
      "karabiner-elements"
      "keycastr"
      "macskk"
      "microsoft-edge"
      "obsidian"
      "ogdesign-eagle"
      "ollama-app"
      # "barutsrb/tap/omniwm"
      "orbstack"
      "raycast"
      # "steipete/tap/repobar"
      "slack"
      "slack-cli"
      "smoothcsv"
      # "thaw" # cask 化されたので brews から移動
      # tailscale-app removed: using nix-darwin services.tailscale instead
      "visual-studio-code"
      "wezterm@nightly"
      # "zettlr"
    ];
  };

  # macOS system settings
  system = {
    # Used for backwards compatibility
    stateVersion = 5;

    defaults = {
      # Dock settings
      dock = {
        autohide = true;
        show-recents = false;
      };

      # Finder settings
      finder = {
        AppleShowAllExtensions = true;
        ShowPathbar = true;
        FXEnableExtensionChangeWarning = false;
      };

      # Global settings
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
      };

      # OmniWM requires "Displays have separate Spaces" to be disabled.
      # In nix-darwin this is represented by spaces spanning displays.
      spaces.spans-displays = true;
    };
  };

  # Enable Touch ID for sudo (new option name)
  security.pam.services.sudo_local.touchIdAuth = true;

  # Set hostname
  networking.hostName = hostname;

  # Create /etc/zshrc for compatibility
  programs.zsh.enable = true;

  # User configuration
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };
}
