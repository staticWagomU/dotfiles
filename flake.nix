{
  description = "輪ごむのお部屋";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    fisher = {
      url = "github:jorgebucaran/fisher";
      flake = false;
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vim-overlay = {
      url = "github:kawarimidoll/vim-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zeno-zsh = {
      url = "github:yuki-yano/zeno.zsh";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      flake-parts,
      treefmt-nix,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [ treefmt-nix.flakeModule ];

      perSystem =
        { pkgs, system, ... }:
        {
          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              jsonfmt.enable = true;
              yamlfmt.enable = true;
              taplo.enable = true; # TOML
              shfmt.enable = true;
            };
          };

          # 開発用シェル（必要に応じて）
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nixpkgs-fmt
              nil
            ];
          };

          packages.codex = (import inputs.nixpkgs {
            inherit system;
            overlays = [ (import ./nix/overlays/codex-overlay.nix) ];
          }).codex;

          apps.codex = {
            type = "app";
            program = "${pkgs.codex}/bin/codex";
          };
        };

      flake =
        let
          mkHomeConfig =
            {
              username,
              hostname,
              system,
              modules,
              extraOverlays ? [ ],
            }:
            let
              # node2nixパッケージを追加するオーバーレイ
              nodePackagesOverlay = final: prev: {
                nodePkgs = final.callPackage ./node2nix { };
              };

              pkgs = import inputs.nixpkgs {
                inherit system;
                config = {
                  allowUnfree = true;
                  allowBroken = true;
                };
                overlays = [
                  inputs.emacs-overlay.overlays.default
                  inputs.vim-overlay.overlays.default
                  nodePackagesOverlay
                  (import ./nix/overlays/codex-overlay.nix)
                ]
                ++ extraOverlays;
              };
            in
            home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = modules;
              extraSpecialArgs = {
                inherit
                  inputs
                  username
                  hostname
                  system
                  pkgs
                  ;
              };
            };
        in
        {
          homeConfigurations = {
            MacBookAir = mkHomeConfig {
              username = "wagomu";
              hostname = "MacBookAir";
              system = "aarch64-darwin";
              modules = [
                ./home-manager/common.nix
                ./home-manager/gui.nix
              ];
            };

            ThinkpadT14Gen3 = mkHomeConfig {
              username = "wagomu";
              hostname = "ThinkpadT14Gen3";
              system = "x86_64-linux";
              modules = [
                ./home-manager/common.nix
                # .home-manager/linux.nix
              ];
            };
          };

        };

    };
}
