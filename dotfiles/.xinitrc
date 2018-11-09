#!/bin/sh

## WARNING: If started from tty on a multi-seat, user must run:
##
##    startx & vlock
##
## to ensure the X locker cannot be passed

## Run site init scripts
if test -d /etc/X11/xinit/xinitrc.d ; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh
	do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

## local xprofile
test -f ~/.xprofile && . ~/.xprofile

command -v xsetroot >/dev/null 2>&1 && xsetroot -solid "#282A36"

## start session
if test $# -eq 1 && command -v $1 >/dev/null 2>&1 ; then
	exec $1
else
	echo "Starting at $(date)" >> ~/.cache/i3/log
	exec i3 -V -d all >> ~/.cache/i3/log
fi
