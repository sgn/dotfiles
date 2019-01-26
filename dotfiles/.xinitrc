#!/bin/sh

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

## X bindkeys
xbindkeys || true

## Lock on sleep
command -v slock >/dev/null && xss-lock -- slock &

command -v unclutter >/dev/null 2>&1 && unclutter &

if command -v dunst >/dev/null 2>&1; then
	XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
	dunst &
	while true; do
		if test -r "$XDG_CONFIG_HOME/dunst/battery.sh" ; then
			/bin/sh "$XDG_CONFIG_HOME/dunst/battery.sh"
		fi
		sleep 180
	done&
fi

slstatus &
## start session
DWM=dwm
if test $# -eq 1 && command -v $1 >/dev/null 2>&1 ; then
	DWM="$1"
fi
exec $STARTUP $DWM >${HOME}/.cache/dwm.log
