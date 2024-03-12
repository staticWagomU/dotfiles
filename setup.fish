#!/bin/fish

git clone https://github.com/staticWagomU/dotfiles.git ~/dotfiles
git clone https://github.com/staticWagomU/dotvim.git ~/dotvim

# dotfilesのsetupスクリプトを実行
bash ~/dotfiles/mklink.sh
bash ~/dotvim/mklink.sh

# aquaをインストール
echo "install aqua"
curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v2.3.0/aqua-installer | bash

aqua i

# vimのHEADビルド



# NeovimのHEADビルド
cd /usr/local/src
sudo git clone https://github.com/neovim/neovim.git

cd neovim
sudo apt-get install -y ninja-build gettext cmake unzip curl build-essential
sudo apt install -y cmake automake libtool libtool-bin
sudo make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
