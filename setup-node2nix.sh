#!/usr/bin/env bash

# node2nixのセットアップスクリプト

echo "Creating node-packages directory..."
mkdir -p node-packages

echo "Copying node-packages.json..."
cp node-packages.json node-packages/

cd node-packages

echo "Generating package.json..."
cat >package.json <<'EOF'
{
  "name": "claude-code-packages",
  "version": "1.0.0",
  "description": "Node packages for nix",
  "dependencies": {
    "@anthropic-ai/claude-code": "latest"
  }
}
EOF

echo "Running node2nix..."
nix-shell -p node2nix --run "node2nix -i package.json -o node-packages.nix -c composition.nix -e node-env.nix"

echo "Creating default.nix..."
cat >default.nix <<'EOF'
{ pkgs ? import <nixpkgs> {} }:

let
  nodePackages = import ./composition.nix {
    inherit pkgs;
    inherit (pkgs) nodejs;
    inherit (pkgs.stdenv.hostPlatform) system;
  };
in
nodePackages."@anthropic-ai/claude-code"
EOF

echo "Setup complete!"
echo "Now run 'nix flake update' and rebuild your configuration."
