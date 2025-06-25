#!/bin/bash

cd node2nix/
nix-shell -p nodePackages.node2nix --command "node2nix -i ./node-packages.json -o node-packages.nix"
nix flake update
nix fmt

git add flake.lock node2nix/node-packages.nix
git commit -m "Update node2nix and flake.lock"
