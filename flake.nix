{
  description = "輪ごむのお部屋";

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
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

          packages.codex =
            (import inputs.nixpkgs {
              inherit system;
              overlays = [ (import ./nix/overlays/codex-overlay.nix) ];
            }).codex;

          packages.octorus =
            (import inputs.nixpkgs {
              inherit system;
              overlays = [ (import ./nix/overlays/octorus-overlay.nix) ];
            }).octorus;

          apps.codex = {
            type = "app";
            program = "${pkgs.codex}/bin/codex";
          };
        };

      flake =
        let
          # Common overlays
          commonOverlays = [
            inputs.emacs-overlay.overlays.default
            inputs.vim-overlay.overlays.default
            (import ./nix/overlays/codex-overlay.nix)
            (import ./nix/overlays/octorus-overlay.nix)
          ];

          # node2nix overlay
          nodePackagesOverlay = final: prev: {
            nodePkgs = final.callPackage ./node2nix { };
          };

          mkHomeConfig =
            {
              username,
              hostname,
              system,
              modules,
              extraOverlays ? [ ],
            }:
            let
              pkgs = import inputs.nixpkgs {
                inherit system;
                config = {
                  allowUnfree = true;
                  allowBroken = true;
                };
                overlays = commonOverlays ++ [ nodePackagesOverlay ] ++ extraOverlays;
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

          mkDarwinConfig =
            {
              username,
              hostname,
              system ? "aarch64-darwin",
              darwinModules ? [ ],
              homeModules ? [ ],
              extraOverlays ? [ ],
            }:
            nix-darwin.lib.darwinSystem {
              inherit system;
              specialArgs = {
                inherit inputs username hostname;
              };
              modules = darwinModules ++ [
                # Home Manager as a Darwin module
                home-manager.darwinModules.home-manager
                {
                  nixpkgs.overlays = commonOverlays ++ [ nodePackagesOverlay ] ++ extraOverlays;
                  nixpkgs.config.allowUnfree = true;

                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    extraSpecialArgs = {
                      inherit
                        inputs
                        username
                        hostname
                        system
                        ;
                    };
                    users.${username} = {
                      imports = homeModules;
                    };
                  };
                }
              ];
            };
        in
        {
          # nix-darwin configurations (recommended for macOS)
          darwinConfigurations = {
            MacBookAir = mkDarwinConfig {
              username = "wagomu";
              hostname = "MacBookAir";
              darwinModules = [ ./darwin/default.nix ];
              homeModules = [
                ./home-manager/common.nix
                ./home-manager/mac.nix
                ./home-manager/gui.nix
              ];
            };

            MacBookPro = mkDarwinConfig {
              username = "wagomu";
              hostname = "MacBookPro";
              darwinModules = [ ./darwin/default.nix ];
              homeModules = [
                ./home-manager/common.nix
                ./home-manager/mac.nix
                ./home-manager/gui.nix
              ];
            };
          };

          # Standalone home-manager configurations (for Linux)
          homeConfigurations = {
            WSL = mkHomeConfig {
              username = "wagomu";
              hostname = "ThinkpadT14Gen3";
              system = "x86_64-linux";
              modules = [
                ./home-manager/common.nix
                ./home-manager/linux.nix
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

            NucBox3 = mkHomeConfig {
              username = "wagomu";
              hostname = "NucBox3";
              system = "x86_64-linux";
              modules = [
                ./home-manager/common.nix
                ./home-manager/linux.nix
              ];
            };
          };

        };

    };

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
    arto.url = "github:arto-app/Arto";
  };
}
