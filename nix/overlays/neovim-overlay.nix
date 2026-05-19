final: prev: {
  neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (old: {
    doCheck = false;
    doInstallCheck = false;
  });
}
