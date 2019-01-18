#!/bin/sh

if ! command -v xset >/dev/null 2>&1; then
	return
fi

for x in /tmp/.X11-unix/*; do
	DISPLAY=":${x#/tmp/.X11-unix/X}" xset s activate || true
done
