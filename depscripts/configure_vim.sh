#!/bin/bash
cp vimrc ~/.vimrc
echo "Install fuzzy searcher"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
sleep 2
~/.fzf/install
echo "Fuzzy installation done"

echo "Installing and configuring Vundle"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

echo "Installing YouComplete This may not work if it is Ubuntu 14.04-----"
sudo apt-get install build-essential cmake

# this resolved 'YCM core library not detected' error
# Source: https://github.com/Valloric/YouCompleteMe/blob/master/README.md#ubuntu-linux-x64
sudo apt-get install python-dev python3-dev

cd ~/.vim/bundle/YouCompleteMe
./install.py
cd

echo "Vim configuration Has been completed"
