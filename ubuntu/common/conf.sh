#!/bin/bash
readonly INIT_CODEDIR=~/coding
if [ ! -d $INIT_CODEDIR ]; then
    mkdir -p $INIT_CODEDIR
fi
cd $INIT_CODEDIR
git clone git@github.com:sailxjx/conf.git
sudo cp conf/vim/colors/* /usr/share/vim/vim73/colors/
cp conf/linux/.vimrc conf/linux/.bashrc conf/linux/.profile ~/
