#!/bin/sh

xcpdiff() {
	cmp -s "$1" "$DESTDIR/etc/$1" || cp "$1" "$DESTDIR/etc/$1"
}

xlink() {
	[ -h "$2" ] || [ -f "$2" ] && rm "$2"
	if [ -d "$2" ]; then
		rmdir "$2" || exit 1
	fi
	ln -s "$1" "$2"
}

for f in ./install-etc.d/*.sh; do
	 test -r "$f" && . "$f"
done
