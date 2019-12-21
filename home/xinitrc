#!/bin/sh

exec >/tmp/xinitrc.$(hostname).$USER.$(date +%Y%m%dT%H%M%S)
exec 2>&1

## Run site init scripts
if test -d /etc/X11/xinit/xinitrc.d ; then
	for f in /etc/X11/xinit/xinitrc.d/*
	do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

## local xprofile
test -f ~/.xprofile && . ~/.xprofile

## start session
DWM=dwm
if test $# -eq 1 && command -v $1 >/dev/null 2>&1 ; then
	DWM="$1"
fi
exec $STARTUP $DWM
