#!/bin/bash
run(){
	echo run commands: "$*"
	$*
}

mod(){
	echo load mudule: "$1"
	exec $INIT_BASEDIR/$INIT_SYSTEM/$1.sh
}
