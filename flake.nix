
{
  description = "輪ごむのお部屋";

  inputs = {
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
        "aarch64-linux"
        "x86_64-linux"
      ];

#       perSystem =
#         { ... }:
#         {
#           treefmt = {
#             projectRootFile = "flake.nix";
#             programs = {
#               actionlint.enable = true;
#               nixfmt.enable = true;
#               taplo.enable = true;
#               jsonfmt.enable = true;
#               yamlfmt.enable = true;
#               fish_indent.enable = true;
#               stylua.enable = true;
#               shfmt.enable = true;
#               prettier.enable = true;
#             };
#           };
#         };

#       flake = {
#         darwinConfigurations = {
#           OPL2212-2 = import ./hosts/OPL2212-2 { inherit inputs; };
#         };
#         nixosConfigurations = {
#           # X13Gen2 = import ./hosts/X13Gen2 { inherit inputs; };
#         };
#         nixOnDroidConfigurations = {
#           OPPO-A79 = import ./hosts/OPPO-A79 { inherit inputs; };
#         };
#       };

      flake = {
        homeConfigurations =
          let
            username = "wagomu";
            hostname = "MacBookAir";
            system = "aarch64-darwin";
#             pkgs = nixpkgs.legacyPackages.${system};
            pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [
                inputs.neovim-nightly-overlay.overlays.default
                inputs.emacs-overlay.overlays.default
                inputs.vim-overlay.overlays.default
              ];
            };
          in
          {
            "${username}@${hostname}" = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;

              modules = [
                ./home.nix
              ];

              extraSpecialArgs = { inherit inputs username hostname; };
            };
          };

        # nixosModules.default = import ./module.nix;
      };
    };
}
