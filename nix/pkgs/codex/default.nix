{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "codex";
  version = "0.104.0";

  src = fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    tag = "rust-v${version}";
    hash = "sha256-spWb/msjl9am7E4UkZfEoH0diFbvAfydJKJQM1N1aoI=";
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
    lockFile = ./Cargo.lock;
    allowBuiltinFetchGit = true;
  };

  doCheck = false;

  buildPhase = ''
    runHook preBuild
    pushd ${cargoRoot}
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
      "${cargoRoot}/target/release/codex" \
      "target/''${CARGO_BUILD_TARGET:-}/release/codex" \
      "${cargoRoot}/target/''${CARGO_BUILD_TARGET:-}/release/codex"; do
      if [ -f "$p" ]; then binPath="$p"; break; fi
    done
    if [ -z "$binPath" ]; then
      binPath=$(ls -1d ${cargoRoot}/target/*/release/codex 2>/dev/null | head -n1 || true)
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
