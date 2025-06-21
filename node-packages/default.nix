{ pkgs ? import <nixpkgs> {} }:

let
  nodePackages = import ./composition.nix {
    inherit pkgs;
    inherit (pkgs) nodejs;
    inherit (pkgs.stdenv.hostPlatform) system;
  };
in
nodePackages."@anthropic-ai/claude-code"
