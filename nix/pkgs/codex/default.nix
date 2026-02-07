{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "codex";
  version = "0.31.0"; # display version; source is pinned by commit below

  # Build from upstream Git commit (workspace lives at codex-rs)
  src = fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    rev = "43809a454e5c6348418fc2d5ace1eb0a98f59847";
    sha256 = "sha256-BZrEVbLrFYb51sqd8yWufZXsbtBS6m1lLu4seTWSF3k=";
  };

  # Cargo workspace root
  cargoRoot = "codex-rs";

  # Only build the codex bin
  cargoBuildFlags = [
    "--bin"
    "codex"
  ];

  # Cargo dependency lock hash; set after first build attempt
  cargoHash = "sha256-tLwvr7OaxrKHCAdsEtT0t34dOE4iBJ0Buh89igPmH2E=";

  # Skip running tests during build (optional but safer for CLI tools)
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
    # Optional fields can be filled once confirmed
    homepage = "https://github.com/openai/codex";
    # license = licenses.mit;
  };
}
