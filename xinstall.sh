#!/bin/sh
# Script intended to be used by Makefile

: ${CP:=cp -R -f}
: ${LN:=ln -f}
: ${MKDIR:=mkdir -p}
: ${TOUCH:= touch}

SOURCE=$1
TARGET="$HOME/.$SOURCE"

command ${MKDIR} "${TARGET%/*}"

_parent="${TARGET%/run}"

if [ "${TARGET##*/}" = run ] &&
   : [ ! -e "$_parent/supervise" ] &&
   [ ! -L "$_parent/supervise" ]; then
	_sv="${_parent##*/}"
	if [ "$_sv" = log ]; then
		_grandma=${_parent%/log}
		_sv="${_grandma##*/}-log"
	fi
	echo "\tINSTALL ${_parent}/supervise"
	rm -rf "$_parent/supervise"
	command ${LN} -s "/run/x-user/$USER/runit/supervise.$_sv" \
		"$_parent/supervise"
fi

echo "\tINSTALL ${TARGET}"
command ${LN} "$SOURCE" "$TARGET"
