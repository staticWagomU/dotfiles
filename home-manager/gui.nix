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
  ];

  home.packages = [
    pkgs.wezterm
  ];

  home.sessionVariables = {
    SHELL = "${pkgs.fish}/bin/fish";
  };
}
