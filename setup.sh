#!/bin/bash

echo "Start setup"
sudo apt update
sudo apt upgrade -y
sudo apt autoremove
if ! type "git" > /dev/null 2>&1; then
  echo "install git"
  sudo apt install git
fi

if ! type "fish" > /dev/null 2>&1; then
  echo "install fish"
  sudo apt install fish
fi

# fishをデフォルトシェルにする
chsh -s /usr/bin/fish
fish

# ここから先は fish で実行
curl -sSfL https://raw.githubusercontent.com/staticWagomU/dotfiles/config/fish/config.fish | fish
