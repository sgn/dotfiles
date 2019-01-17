#!/bin/sh

CDPATH=
export CDPATH
BASEDIR=$(readlink -f "$0")
BASEDIR="${BASEDIR%/*}"
cd "$BASEDIR"

for f in ./install-etc.d/*.sh; do
	 test -r "$f" && . "$f"
done

if command -v rsync >/dev/null 2>&1; then
	rsync -ruvl etc /
else
	cp -r etc / 
fi
