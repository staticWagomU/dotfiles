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
    inputs.arto.packages.${system}.default
  ];

  home.sessionVariables = {
    SHELL = "${pkgs.fish}/bin/fish";
  };
}
