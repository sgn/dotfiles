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

for f in ./install-etc.d/*.sh; do
	 test -r "$f" && . "$f"
done

if command -v rsync >/dev/null 2>&1; then
	rsync -ruvl etc "$DESTDIR"
else
	cp -r etc "$DESTDIR"
fi
