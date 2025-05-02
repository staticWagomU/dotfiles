{ config, pkgs, inputs, username, hostname, system, ... }:

{
  home.packages = [
    pkgs.wezterm
  ];
}
