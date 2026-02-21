{
  lib,
  rustPlatform,
  fetchFromGitHub,
  version,
  srcHash,
  cargoLockFile,
}:

rustPlatform.buildRustPackage {
  pname = "octorus";
  inherit version;

  src = fetchFromGitHub {
    owner = "ushironoko";
    repo = "octorus";
    tag = "v${version}";
    hash = srcHash;
  };

  cargoBuildFlags = [
    "--bin"
    "or"
  ];

  cargoLock = {
    lockFile = cargoLockFile;
    allowBuiltinFetchGit = true;
  };

  doCheck = false;

  meta = with lib; {
    description = "TUI PR review tool for GitHub with Vim-style keybindings";
    mainProgram = "or";
    homepage = "https://github.com/ushironoko/octorus";
    license = licenses.mit;
  };
}
