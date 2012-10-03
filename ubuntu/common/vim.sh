#!/bin/bash
wget -c ftp://ftp.vim.org/pub/vim/unix/vim-7.3.tar.bz2
tar -xvf vim-7.3.tar.bz2
run cd vim73
mod lib/libncurses5
run ./configure
run make && make install
ln -s /usr/local/vim73/bin/* /usr/local/bin/
