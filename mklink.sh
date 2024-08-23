#!/bin/bash

rm -rf ~/.config/wezterm/wezterm.lua
rm -rf ~/.wezterm.lua
rm -rf ~/.config/fish/config.fish
rm -rf ~/.config/fish/functions
rm -rf ~/aqua.yaml
rm -rf ~/.gitconfig
ln -s ~/dotfiles/config/wezterm ~/.config/wezterm
ln -s ~/dotfiles/config/wezterm/wezterm.lua ~/.wezterm.lua
ln -s ~/dotfiles/config/fish/config.fish ~/.config/fish/config.fish
ln -s ~/dotfiles/config/fish/functions ~/.config/fish/functions
ln -s ~/dotfiles/config/aqua.yaml ~/aqua.yaml
ln -s ~/dotfiles/config/.tigrc ~/.tigrc
cp ~/dotfiles/config/.gitconfig_other ~/.gitconfig
