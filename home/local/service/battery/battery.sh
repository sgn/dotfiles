#!/bin/sh

# gratefully exit if no battery exist
test -d /sys/class/power_supply/BAT0 || exit 0
# or if it's charging
for f in /sys/class/power_supply/BAT*/status; do
	read -r status < "$f"
	[ Charging = "$status" ] && exit 0
done

if command -v dunstify >/dev/null 2>&1; then
	NOTIFY_SEND="dunstify -r 13277"
elif command -v notify-send >/dev/null 2>&1; then
	NOTIFY_SEND="notify-send"
else
	exit 1
fi

total_capacity=0
num_bat=0
for d in /sys/class/power_supply/BAT*; do
	num_bat=$(( num_bat + 1 ))
	if [ -e "$d/capacity" ]; then
		capacity=$(cat "$d/capacity")
	else
		full=$(cat "$d/energy_full")
		now=$(cat "$d/energy_now")
		capacity=$(( 100 * now / full ))
	fi
	total_capacity=$(( total_capacity + capacity ))
done
pct=$(( total_capacity / num_bat ))

[ -t 1 ] && echo "Battery: $pct"

dunst_pid=$(ps -C dunst -o pid=)
[ $? -ne 0 ] && exit 0
eval "$(printf "/proc/%d/environ\n" $dunst_pid |
	xargs grep -hz '^DBUS_SESSION_BUS_ADDRESS=')"
export DBUS_SESSION_BUS_ADDRESS

if test "$pct" -lt 15 ; then
	exec $NOTIFY_SEND -i battery -u critical "Super Low Battery"
elif test "$pct" -lt 25 ; then
	exec $NOTIFY_SEND -i battery "Low Battery"
fi
