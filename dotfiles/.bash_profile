#!/bin/bash
[[ -f ~/.profile ]] && . ~/.profile

if [ -z "$DISPLAY" ] && [ "$(tty)" = '/dev/tty1' ] ; then
	exec xinit -- vt01
else
	[[ -f ~/.bashrc ]] && . ~/.bashrc
fi
