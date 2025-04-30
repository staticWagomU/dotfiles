{
  description = "輪ごむのお部屋";

  inputs = {
    # Nixpkgs (Nix Packages collection) の Flake を指定
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # または安定版 "github:NixOS/nixpkgs/nixos-24.05" など

    # Home Manager の Flake を指定
    home-manager = {
      url = "github:nix-community/home-manager";
      # Home Manager が使う Nixpkgs を上で指定したものに合わせる
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      # --- システムアーキテクチャを指定 ---
      # あなたのMacのアーキテクチャに合わせてください
      # Intel Mac の場合: "x86_64-darwin"
      # Apple Silicon (M1/M2/M3) Mac の場合: "aarch64-darwin"
      # わからない場合はターミナルで `uname -m` を実行して確認
      system = "aarch64-darwin";

      # --- ユーザー名とホスト名を指定 ---
      # ユーザー名は `whoami` コマンドで、ホスト名は `hostname` コマンドで確認できます
      username = "wagomu"; # <---- ここを自分のユーザー名に変更！
      hostname = "MacBookAir"; # <---- ここを自分のホスト名に変更！

      # Nixpkgs のパッケージセットを取得
      pkgs = nixpkgs.legacyPackages.${system};

    in {
      # Home Manager の設定を定義
      homeConfigurations."${username}@${hostname}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs; # 上で定義したパッケージセットを渡す

        # Home Manager の設定本体 (home.nix) を読み込む
        modules = [ ./home.nix ];

        # オプション: 追加の引数を home.nix に渡す場合
        # extraSpecialArgs = { inherit inputs; };
      };
    };
}
