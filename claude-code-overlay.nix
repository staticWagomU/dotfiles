final: prev: {
  nodePackages = prev.nodePackages // {
    claude-code = final.callPackage ./node-packages/default.nix {};
  };
}
