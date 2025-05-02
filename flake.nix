{
  description = "輪ごむのお部屋";

  inputs = {
    # ... (inputs は変更なし) ...
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
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
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vim-overlay = {
      url = "github:kawarimidoll/vim-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem = { pkgs, system, ... }: {
      };

      flake = {
            mkHomeConfig = { username, hostname, system, modules, extraOverlays ? [] }:
              let
                pkgs = import inputs.nixpkgs {
                  inherit system;
                  overlays = [
                    inputs.neovim-nightly-overlay.overlays.default
                    inputs.emacs-overlay.overlays.default
                    inputs.vim-overlay.overlays.default
                  ] ++ extraOverlays;
                };
              in
              home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                modules = modules;
                extraSpecialArgs = {
                  inherit inputs username hostname system pkgs;
                };
              };

          {
            MacBookAir = mkHomeConfig {
              username = "wagomu";
              hostname = "MacBookAir";
              system = "aarch64-darwin";
              modules = [ ./home-common.nix ./home-mac.nix ];
            };

#             ThinkpadT14 = mkHomeConfig {
#               hostname = "ThinkpadT14";
#               system = "x86_64-linux";
#               modules = [ ./home-common.nix ./home-linux.nix ];
#             };
          };
      };
    };
}
