#!/bin/sh

CDPATH=
export CDPATH
BASEDIR=$(readlink -f "$0")
BASEDIR="${BASEDIR%/*}"
cd "$BASEDIR" || exit

case "$1" in
	DESTDIR=*) DESTDIR=${1#DESTDIR=} ;;
esac

DESTDIR=${DESTDIR:=/}

xcpdiff() {
	cmp -s "$1" "$DESTDIR/etc/$1" || cp "$1" "$DESTDIR/etc/$1"
}

xlink() {
	[ -h "$2" ] || [ -f "$2" ] && rm "$2"
	[ -d "$2" ] && rmdir "$2"
	ln -s "$1" "$2"
}

for f in ./install-etc.d/*.sh; do
	 test -r "$f" && . "$f"
done
