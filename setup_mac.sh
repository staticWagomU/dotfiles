#!/bin/bash

echo "Start setup"

bash ~/dotfiles/mklink.sh
bash ~/dotvim/mklink.sh

if ! type "brew" >/dev/null 2>&1; then
  echo "Install brew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if ! type "fish" >/dev/null 2>&1; then
  echo "Install fish"
  brew install fish
  # fishをデフォルトシェルにする
  echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
  chsh -s /opt/homebrew/bin/fish
  fish
fi

# WezTerm をインストール
if [ ! -d "/Applications/WezTerm.app" ]; then
  echo "Install WezTerm"
  brew install --cask wezterm
else
  echo "WezTerm is already installed"
fi

# 1Password をインストール
if [ ! -d "/Applications/1Password.app" ]; then
  echo "Install 1Password"
  brew install --cask 1password
else
  echo "1Password is already installed"
fi

# denoをインストール
if ! type "deno" >/dev/null 2>&1; then
  echo "Install deno"
  curl -fsSL https://deno.land/install.sh | sh
fi

# aquaをインストール
if ! type "aqua" >/dev/null 2>&1; then
  echo "Install aqua"
  brew install aquaproj/aqua/aqua

  aqua i
fi

# Vim/Neovimをインストール
if ! type "vim" >/dev/null 2>&1; then
  if [ ! -d "~/.vim" ]; then
    mkdir ~/.vim
  fi
  echo "Install vim"
  brew install vim --HEAD
fi

if ! type "nvim" >/dev/null 2>&1; then
  echo "Install nvim"
  brew install nvim --HEAD
fi

if ! type "proto" >/dev/null 2>&1; then
  brew install proto

  proto install node
  proto install npm
  proto install pnpm
fi

echo "Finish setup"
