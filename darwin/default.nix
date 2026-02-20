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
      "pakerwreah/calendr"
      "sst/tap"
      "steipete/tap"
      "yakitrak/yakitrak"
    ];

    brews = [
      "atlassian/acli/acli"
      "ballerina"
      "cloud-sql-proxy"
      "colima"
      "curl"
      "devcontainer"
      "docker"
      "docker-compose"
      "duckdb"
      "ekphos"
      "eza"
      "gcc"
      "lilypond"
      "lnav"
      "murex"
      "mysql"
      "ollama"
      "opencode"
      "openjdk@21"
      "portaudio"
      "postgresql@16"
      "swiftformat"
      "tbls"
      "terminal-notifier"
      "tmux"
      "tree"
      "volta"
      "yakitrak/yakitrak/obsidian-cli"
      "zellij"
      # tailscale CLI is provided by nix-darwin services.tailscale
    ];

    casks = [
      "1password"
      "aqua-voice"
      "azookey"
      "bitwarden"
      "pakerwreah/calendr/calendr"
      "claude"
      "cleanshot"
      "cyberduck"
      "drawio"
      "dropbox"
      "gcloud-cli"
      "ghostty"
      "google-chrome"
      "iterm2"
      "itsycal"
      "karabiner-elements"
      "keycastr"
      "macskk"
      "microsoft-edge"
      "obsidian"
      "ogdesign-eagle"
      "ollama-app"
      "orbstack"
      "raycast"
      "steipete/tap/repobar"
      "slack"
      "slack-cli"
      "smoothcsv"
      # tailscale-app removed: using nix-darwin services.tailscale instead
      "visual-studio-code"
      "wezterm@nightly"
      "zettlr"
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
