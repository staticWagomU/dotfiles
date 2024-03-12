#!/bin/bash

rm ~/.config/wezterm/wezterm.lua
ln -s ~/dotfiles/config/wezterm.lua ~/.config/wezterm/wezterm.lua
rm ~/.config/fish/config.fish
ln -s ~/dotfiles/config/fish ~/.config/fish/config.fish
rm ~/aqua.yaml
ln -s ~/dotfiles/config/aqua.yaml ~/aqua.yaml
rm ~/.gitconfig
ln -s ~/dotfiles/config/.gitconfig ~/.gitconfig
