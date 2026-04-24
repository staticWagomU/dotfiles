final: prev:
let
  override =
    pkg:
    (pkg.override {
      osxkeychainSupport = false;
      rustSupport = false;
    }).overrideAttrs (old: rec {
      version = "2.54.0";
      src = prev.fetchurl {
        url = "https://www.kernel.org/pub/software/scm/git/git-${version}.tar.xz";
        hash = "sha256-9okWI2TBDeee+Jqo2/SHMesFfjTtu9IKylEM4BVGgaM=";
      };
      # osxkeychain パッチは 2.54 で upstream マージ済み。nixpkgs が追従するまで除外する
      patches = builtins.filter (
        p:
        !(prev.lib.hasInfix "osxkeychain" (baseNameOf (toString p)))
      ) old.patches;
    });
in
{
  git = override prev.git;
  gitMinimal = override prev.gitMinimal;
}
