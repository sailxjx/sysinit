#!/bin/bash
cd ~/Downloads
wget -c ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.31.tar.bz2 -O pcre-8.31.tar.bz2
tar -xvf pcre-8.31.tar.bz2
cd pcre-8.31
./configure && make && sudo make install

