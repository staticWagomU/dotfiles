{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "octorus";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "ushironoko";
    repo = "octorus";
    tag = "v${version}";
    hash = "sha256-fg5yy60A7YzR+yVOGJCJO4ghO6SIdwEYCB+j9y4m15M=";
  };

  cargoBuildFlags = [
    "--bin"
    "or"
  ];

  cargoHash = "sha256-3ZKi7BcXHO2kgYw6mFMtFBtCJRfXimWMYAN7yvV2ccs=";

  doCheck = false;

  meta = with lib; {
    description = "TUI PR review tool for GitHub with Vim-style keybindings";
    mainProgram = "or";
    homepage = "https://github.com/ushironoko/octorus";
    license = licenses.mit;
  };
}
