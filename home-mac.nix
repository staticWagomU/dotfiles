{ config, pkgs, inputs, username, hostname, system, ... }:

{
  home.packages = [
    pkgs.wezterm
  ];

  home.sessionVariables = {
    SHELL = "${pkgs.fish}/bin/fish";
  };
}
