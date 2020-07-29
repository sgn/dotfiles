#!/bin/sh

[ -d "$DESTDIR/etc/sv" ] || return

. "${0%/*}/common.sh"
cd "${0%/*}/.."

for dir in etc/sv/*; do
	name="${dir#etc/sv/}"
	mkdir -p "$DESTDIR/$dir"
	xcpdiff "$dir/run"
	if [ -f "$dir/finish" ]; then
		xcpdiff "$dir/finish"
	else
		rm -f "$DESTDIR/$dir/finish"
	fi
	xlink "/run/runit/supervise.$name" "$DESTDIR/$dir/supervise"
	if [ -d "$dir/log" ]; then
		mkdir -p "$DESTDIR/$dir/log"
		xcpdiff "$dir/log/run"
		xlink "/run/runit/supervise.$name-log" "$DESTDIR/$dir/log/supervise"
	fi
done
