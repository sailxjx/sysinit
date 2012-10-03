#!/bin/bash
readonly INIT_USER=tristan
cd ~/Downloads
wget -c http://downloads.sourceforge.net/project/zsh/zsh/5.0.0/zsh-5.0.0.tar.bz2 -O zsh-5.0.0.tar.bz2
tar -xvf zsh-5.0.0.tar.bz2
cd zsh-5.0.0
./configure && make && sudo make install
cd ~
git clone git@github.com:sailxjx/oh-my-zsh.git .oh-my-zsh
cp .oh-my-zsh/.zshrc .
sudo usermod -s /usr/local/bin/zsh $INIT_USER
exit 0
