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
  homeDir = config.home.homeDirectory;
  scriptsDir = "${homeDir}/.claude/scripts";
in
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

		python313Packages.mlx

    # Database tools
    duckdb # Analytical database

    # Development tools
    terminal-notifier # macOS notifications from CLI
  ];

  # launchd agents for journal automation
  launchd.agents = {
    claude-journal-watcher = {
      enable = true;
      config = {
        Label = "com.user.claude-journal-watcher";
        ProgramArguments = [
          "/bin/bash"
          "-c"
          "exec ${scriptsDir}/watch-and-save.sh"
        ];
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "/tmp/claude-journal-watcher.log";
        StandardErrorPath = "/tmp/claude-journal-watcher.error.log";
        EnvironmentVariables = {
          PATH = "/usr/local/bin:/usr/bin:/bin:/opt/homebrew/bin";
          HOME = homeDir;
        };
        ThrottleInterval = 10;
      };
    };

    codex-journal-watcher = {
      enable = true;
      config = {
        Label = "com.user.codex-journal-watcher";
        ProgramArguments = [
          "/bin/bash"
          "-c"
          "exec ${scriptsDir}/codex-watch-and-save.sh"
        ];
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "/tmp/codex-journal-watcher.log";
        StandardErrorPath = "/tmp/codex-journal-watcher.error.log";
        EnvironmentVariables = {
          PATH = "/usr/local/bin:/usr/bin:/bin:/opt/homebrew/bin";
          HOME = homeDir;
        };
        ThrottleInterval = 10;
      };
    };

    daily-harvest = {
      enable = true;
      config = {
        Label = "com.user.daily-harvest";
        ProgramArguments = [
          "/bin/bash"
          "-c"
          "exec ${scriptsDir}/daily-harvest.sh"
        ];
        StartCalendarInterval = [
          {
            Hour = 0;
            Minute = 5;
          }
        ];
        StandardOutPath = "/tmp/daily-harvest.log";
        StandardErrorPath = "/tmp/daily-harvest.error.log";
        EnvironmentVariables = {
          PATH = "${homeDir}/.local/bin:/usr/local/bin:/usr/bin:/bin:/opt/homebrew/bin";
          HOME = homeDir;
        };
      };
    };

    weekly-review = {
      enable = true;
      config = {
        Label = "com.user.weekly-review";
        ProgramArguments = [ "${scriptsDir}/weekly-review.sh" ];
        StartCalendarInterval = [
          {
            Weekday = 1;
            Hour = 6;
            Minute = 0;
          }
        ];
        StandardOutPath = "/tmp/weekly-review.log";
        StandardErrorPath = "/tmp/weekly-review.error.log";
        WorkingDirectory = "${homeDir}/MyLife";
        EnvironmentVariables = {
          PATH = "/usr/local/bin:/usr/bin:/bin:${homeDir}/.local/bin";
          HOME = homeDir;
        };
      };
    };
  };
}
