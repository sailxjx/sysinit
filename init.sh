#!/bin/bash
export INIT_SYSTEM=ubuntu
export INIT_BASEDIR=$(cd $(dirname $0); pwd)
export INIT_SRCDIR=/usr/local/src
export INIT_USER=tristan
export INIT_CODEDIR=/home/$INIT_USER/coding

. $INIT_BASEDIR/func.sh
cd $INIT_SRCDIR

mod common/conf
