
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
    # flake-parts を使う場合、他の input も flake = false; を指定するか、
    # flake-parts が解釈できる output を持っている必要があります。
    # もしエラーが出る場合は、該当する input に flake = false; を追加してみてください。
    # 例: some-input.flake = false;
  };

  outputs = inputs@{ self, nixpkgs, home-manager, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      # --- Flake 全体の設定 ---
      # サポートするシステムを指定 (Mac環境に合わせて)
      systems = [ "aarch64-darwin" "x86_64-darwin" ];

      # --- システムごとの設定 (perSystem) ---
      # 各システムに対して共通の outputs を定義
      # ここでは特に定義していませんが、将来的にパッケージや開発環境を追加できます
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # 例: この Flake をフォーマットするための treefmt 設定
        # treefmt = inputs.treefmt-nix.lib.mkWrapper pkgs {
        #   projectRootFile = "flake.nix";
        #   programs.nixpkgs-fmt.enable = true;
        # };
      };

      # --- システムに依存しない設定 (flake) ---
      # Home Manager の設定などをここに記述
      flake = {
        # Home Manager の設定
        homeConfigurations =
          let
            # ユーザー名とホスト名を定義
            username = "wagomu";
            hostname = "MacBookAir";
            # Home Manager 設定で使うシステムを指定
            # (homeConfigurations は特定のシステムに紐づくため)
            system = "aarch64-darwin";
            # 指定したシステム用の Nixpkgs を取得
            pkgs = nixpkgs.legacyPackages.${system};
          in
          {
            "${username}@${hostname}" = home-manager.lib.homeManagerConfiguration {
              inherit pkgs

              # Home Manager モジュール (home.nix) を指定
              modules = [
                ./home.nix
                # 他の Home Manager モジュールがあればここに追加
              ];

              # オプション: home.nix 内で inputs を参照できるようにする
              extraSpecialArgs = { inherit inputs username hostname; };
            };
          };

        # 他のシステム非依存の outputs (例: NixOS モジュール) があればここに追加
        # nixosModules.default = import ./module.nix;
      };
    };
}
