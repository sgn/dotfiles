#!/bin/sh

# gratefully exit if no battery exist
test -d /sys/class/power_supply/BAT0 || exit 0
# or if it's charging
grep -qF Charging /sys/class/power_supply/BAT*/status && exit 0

if command -v dunstify >/dev/null 2>&1; then
	NOTIFY_SEND="dunstify -r 13277"
elif command -v notify-send >/dev/null 2>&1; then
	NOTIFY_SEND="notify-send"
else
	exit 1
fi

full="$(cat /sys/class/power_supply/BAT*/energy_full | paste -sd+ - | bc)"
now="$(cat /sys/class/power_supply/BAT*/energy_now | paste -sd+ - | bc)"

pct=$(echo "${now} / (${full} / 100)" | bc)

if test "$pct" -lt 15 ; then
	exec $NOTIFY_SEND -i battery -u critical "Super Low Battery"
elif test "$pct" -lt 25 ; then
	exec $NOTIFY_SEND -i battery "Low Battery"
fi
