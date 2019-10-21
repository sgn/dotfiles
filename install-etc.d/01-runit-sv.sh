#!/bin/sh

[ -d "$DESTDIR/etc/sv" ] || return

for dir in sv/*; do
	name=$(basename "$dir")
	mkdir -p "$DESTDIR/etc/$dir"
	xcpdiff "$dir/run"
	if [ -f "$dir/finish" ]; then
		xcpdiff "$dir/finish"
	else
		rm -f "$DESTDIR/etc/$dir/finish"
	fi
	xlink "/run/runit/supervise.$name" "$DESTDIR/etc/$dir/supervise"
	if [ -d "$dir/log" ]; then
		mkdir -p "$DESTDIR/etc/$dir/log"
		xcpdiff "$dir/log/run"
		xlink "/run/runit/supervise.$name-log" "$DESTDIR/etc/$dir/log/supervise"
	fi
done
