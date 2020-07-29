#!/bin/sh

. "${0%/*}/common.sh"
cd "${0%/*}/.."

mkdir -p "$DESTDIR/etc/zoneshot.d/start"
mkdir -p "$DESTDIR/etc/zoneshot.d/stop"

find etc/zoneshot.d -type f | while read -r name; do
	requirement=$(sed -n 's/^# requires: //p' "$name")
	[ -e "$requirement" ] && xcpdiff "$name"
done
