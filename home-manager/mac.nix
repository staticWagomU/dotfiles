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
}
