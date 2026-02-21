final: prev:
let
  lib = prev.lib;
  versionData = builtins.fromJSON (builtins.readFile ../pkgs/octorus/versions.json);
  locksDir = ../pkgs/octorus/locks;

  mkOctorus =
    { version, srcHash }:
    prev.callPackage ../pkgs/octorus {
      inherit version srcHash;
      cargoLockFile = "${locksDir}/${version}.lock";
    };

  # "0.4.2" -> "004", "1.0.0" -> "000", "0.31.0" -> "031"
  toAttrSuffix =
    version:
    let
      minor = builtins.elemAt (lib.splitString "." version) 1;
    in
    lib.fixedWidthString 3 "0" minor;

in
lib.mapAttrs' (version: meta: {
  name =
    if version == versionData.latest
    then "octorus"
    else "octorus_${toAttrSuffix version}";
  value = mkOctorus { inherit version; inherit (meta) srcHash; };
}) versionData.versions
