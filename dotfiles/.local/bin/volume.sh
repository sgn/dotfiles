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

notify-send -i audio-speaker "Volume: ${volume}"
