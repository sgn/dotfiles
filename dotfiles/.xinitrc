#!/bin/sh

## WARNING: If started from tty on a multi-seat, user must run:
##
##    startx & vlock
##
## to ensure the X locker cannot be passed

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

slstatus &
## start session
DWM=dwm
if test $# -eq 1 && command -v $1 >/dev/null 2>&1 ; then
	DWM="$1"
fi
#if test -z "$DBUS_SESSION_BUS_ADDRESS" \
#		&& command -v dbus-run-session >/dev/null 2>&1 ; then
#	DWM="dbus-run-session -- ${DWM}"
#fi
exec $STARTUP $DWM >${HOME}/.cache/dwm.log
