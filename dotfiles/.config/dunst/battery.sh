#!/bin/sh

# gratefully exit if no battery exist
test -d /sys/class/power_supply/BAT0 || exit 0

grep -qF Charging /sys/class/power_supply/BAT*/status && exit 0

full="$(cat /sys/class/power_supply/BAT*/energy_full | paste -sd+ - | bc)"
now="$(cat /sys/class/power_supply/BAT*/energy_now | paste -sd+ - | bc)"

pct=$(echo "${now} / (${full} / 100)" | bc)

if test "$pct" -lt 15 ; then
	notify-send -i battery -u critical "Super Low Battery"
elif test "$pct" -lt 25 ; then
	notify-send -i battery "Low Battery"
fi
