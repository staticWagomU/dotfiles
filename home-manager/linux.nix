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

  home.packages = with pkgs; [
    volta
    unzip
		curl
  ];
}
