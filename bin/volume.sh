#!/bin/sh

chvol() {
	case $1 in
	up) amixer set Master 2%+ ;;
	down) amixer set Master 2%- ;;
	toggle) amixer set Master toggle ;;
	*)
		echo "Usage: volume.sh up|down|toggle" >&2
		exit 1
		;;
	esac
}

volume=$(chvol "$@" |
	sed -nE '/:.*%/s/[[:space:]]*(.*:).*[[]([0-9]*%)[]].*[[](on|off)[]].*/\1 \2 [\3]/p')

if [ -z "$volume" ]; then
	exit 1
elif command -v dunstify >/dev/null 2>&1; then
	NOTIFY_SEND="dunstify -r 29011"
elif command -v notify-send >/dev/null 2>&1; then
	NOTIFY_SEND="notify-send"
else
	printf '%s\n' "$volume"
	exit
fi
exec $NOTIFY_SEND -i audio-speakers "${volume}"
