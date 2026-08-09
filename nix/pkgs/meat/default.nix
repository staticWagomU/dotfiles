{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

# 上流にタグもリリースも無いため、versions.json + update-package.py 方式は使わず
# commit SHA を直接ピン留めする。更新時は nurl で rev/hash を差し替える:
#   nix run nixpkgs#nurl -- https://github.com/boldsoftware/meat <sha>
buildGoModule {
  pname = "meat";
  version = "0-unstable-2026-08-03";

  src = fetchFromGitHub {
    owner = "boldsoftware";
    repo = "meat";
    rev = "f39f41dfe7b5b37a12b35fdfbaecc7e779855bd3";
    hash = "sha256-fj04sdMiwPxh4F+kBpF5c+YYeKnKCDD9dsIgwAGPoK4=";
  };

  # go.mod に require が一つも無い（標準ライブラリのみ）ため vendor 不要
  vendorHash = null;

  # リポジトリには analysis/ の検証データと meat/ のライブラリコードも含まれる。
  # 実行バイナリだけが必要なので cmd/meat に絞る
  subPackages = [ "cmd/meat" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Abridge a code diff into a reading diff";
    homepage = "https://github.com/boldsoftware/meat";
    license = lib.licenses.mit;
    mainProgram = "meat";
    platforms = lib.platforms.unix;
  };
}
