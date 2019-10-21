#!/bin/sh

find etc -type f -o -type l | while read -r name; do
	xdir=$DESTDIR/$(dirname "$name")
	if [ -d "$xdir" ] && ! cmp -s "$name" "$DESTDIR/$name"; then
		cp "$name" "$DESTDIR/$name"
	fi
done
