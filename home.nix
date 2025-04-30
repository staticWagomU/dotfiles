{ config, pkgs, ... }:

{
  # --- 基本設定 ---
  # 自分のユーザー名とホームディレクトリを指定
  home.username = "wagomu"; # <---- ここを自分のユーザー名に変更！
  home.homeDirectory = "/Users/wagomu"; # <---- ここを自分のホームディレクトリに変更！

  # --- パッケージのインストール ---
  # ここにインストールしたいパッケージを追加していく
  home.packages = [
    pkgs.git
    pkgs.vim
    pkgs.htop
    pkgs.ripgrep
    pkgs.gh
  ];


  home.stateVersion = "24.05"; # <---- 使っている Home Manager のバージョンに合わせる
}
