final: prev:
let
  lib = prev.lib;
  versionData = builtins.fromJSON (builtins.readFile ../pkgs/codex/versions.json);
  locksDir = ../pkgs/codex/locks;

  mkCodex =
    { version, srcHash }:
    prev.callPackage ../pkgs/codex {
      inherit version srcHash;
      cargoLockFile = "${locksDir}/${version}.lock";
    };

  # "0.104.0" -> "104", "0.31.0" -> "031", "0.4.0" -> "004"
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
    then "codex"
    else "codex_${toAttrSuffix version}";
  value = mkCodex { inherit version; inherit (meta) srcHash; };
}) versionData.versions
