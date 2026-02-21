{
  lib,
  rustPlatform,
  fetchFromGitHub,
  version,
  srcHash,
  cargoLockFile,
}:

rustPlatform.buildRustPackage {
  pname = "codex";
  inherit version;

  src = fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    tag = "rust-v${version}";
    hash = srcHash;
  };

  # Cargo workspace root
  cargoRoot = "codex-rs";

  # Only build the codex bin
  cargoBuildFlags = [
    "--bin"
    "codex"
  ];

  # Use cargoLock instead of cargoHash to handle git dependencies
  # (crossterm is pinned to a custom git branch via nornagon/crossterm)
  cargoLock = {
    lockFile = cargoLockFile;
    allowBuiltinFetchGit = true;
  };

  doCheck = false;

  buildPhase = ''
    runHook preBuild
    pushd codex-rs
    cargoBuildHook
    popd
    runHook postBuild
  '';

  # Ensure the binary is installed to $out/bin
  installPhase = ''
    runHook preInstall
    binPath=""
    for p in \
      "target/release/codex" \
      "codex-rs/target/release/codex" \
      "target/''${CARGO_BUILD_TARGET:-}/release/codex" \
      "codex-rs/target/''${CARGO_BUILD_TARGET:-}/release/codex"; do
      if [ -f "$p" ]; then binPath="$p"; break; fi
    done
    if [ -z "$binPath" ]; then
      binPath=$(ls -1d codex-rs/target/*/release/codex 2>/dev/null | head -n1 || true)
    fi
    if [ -z "$binPath" ]; then
      binPath=$(ls -1d target/*/release/codex 2>/dev/null | head -n1 || true)
    fi
    if [ -z "$binPath" ]; then
      echo "codex binary not found in target outputs" >&2
      exit 1
    fi
    install -Dm755 "$binPath" "$out/bin/codex"
    runHook postInstall
  '';

  meta = with lib; {
    description = "codex CLI built from upstream Git via Nix";
    mainProgram = "codex";
    homepage = "https://github.com/openai/codex";
  };
}
