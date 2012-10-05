#!/bin/bash
INIT_GITHUB_DIR=~/coding/github
[[ ! -d $INIT_GITHUB_DIR ]] && mkdir -p $INIT_GITHUB_DIR
cd $INIT_GITHUB_DIR
git clone git://github.com/joyent/node.git
cd node
./configure --prefix=/usr/local/node && make && sudo make install
sudo ln -s /usr/local/node/bin/* /usr/local/bin 
sudo cp -r /usr/local/node/share/man/* /usr/local/share/man
exit 0
