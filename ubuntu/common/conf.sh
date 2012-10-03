#!/bin/bash
. $INIT_BASEDIR/func.sh
run cd $INIT_CODEDIR
# run git clone git@github.com:sailxjx/conf.git
run sudo cp conf/vim/colors/* /usr/share/vim/vim73/colors/
run cp conf/linux/.vimrc conf/linux/.bashrc conf/linux/.profile ~/
