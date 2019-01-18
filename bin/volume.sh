#!/bin/sh

case $1 in
up) amixer set Master 2%+ ;;
down) amixer set Master 2%- ;;
toggle) amixer set Master toggle ;;
*)
	echo "Usage: volume.sh up|down|toggle"
	exit 1
	;;
esac

volume=$(amixer get Master | awk '/%/{print $6=="[off]"?"off":$4}')

if command -v dunstify >/dev/null 2>&1; then
	NOTIFY_SEND="dunstify -r 29011"
elif command -v notify-send >/dev/null 2>&1; then
	NOTIFY_SEND="notify-send"
else
	exit
fi
exec $NOTIFY_SEND -i audio-speaker "Volume: ${volume}"
