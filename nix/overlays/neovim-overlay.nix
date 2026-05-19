final: prev: {
  neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (old: {
    doCheck = false;
    doInstallCheck = false;
    # Why: nightly overlay の installCheckPhase / cmake 由来 functionaltest が
    # Darwin で flaky に死ぬ (treesitter で SIGPIPE)。doCheck フラグでは
    # 止まらないパスを潰すために phase 本体を no-op にする。
    checkPhase = "true";
    installCheckPhase = "true";
  });
}
