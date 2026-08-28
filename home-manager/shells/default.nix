{
  config,
  pkgs,
  ...
}:

# ターミナルエミュレータごとに別のシェルを使うための設定。
#   Alacritty -> nushell (home-manager/gui.nix の alacritty.toml)
#   Ghostty -> PowerShell (config/ghostty/config の command)
# ログインシェル (chsh) は fish のままにしておく。cron・SSH・スクリプトなど
# 端末を経由しない経路の挙動を変えないため。
let
  dotfilesDir = "${config.home.homeDirectory}/dotfiles";
in
{
  home.packages = with pkgs; [
    nushell
    powershell
  ];

  # home-manager が config/env の置き場所 (macOS では
  # ~/Library/Application Support/nushell) を面倒みてくれるので module を使う。
  # 中身は dotfiles を source するだけにして、rebuild なしで編集を反映できるようにする。
  programs.nushell = {
    enable = true;
    extraEnv = ''
      source ${dotfilesDir}/config/nushell/env.nu
    '';
    extraConfig = ''
      source ${dotfilesDir}/config/nushell/config.nu
    '';
  };

  # PowerShell には home-manager module がないため profile を直接リンクする。
  # pwsh は Unix では $PROFILE を ~/.config/powershell/ 配下から読む。
  home.file.".config/powershell/Microsoft.PowerShell_profile.ps1".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/powershell/profile.ps1";
}
