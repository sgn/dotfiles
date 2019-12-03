__battery () {
	local result=''
	local batteries bat capacity energy_full energy_now bat_status
	batteries=( /sys/class/power_supply/BAT*(N) )
	for bat in $batteries ; do
		if [[ -e $bat/capacity ]]; then
			read capacity <$bat/capacity
		else
			read energy_full <$bat/energy_full
			read energy_now <$bat/energy_now
			capacity=$(( 100 * $energy_now / $energy_full))
		fi
		case "$(cat "$bat/status")" in
		Charging) bat_status="^" ;;
		Discharging)
			if [ "$capacity" -lt 20 ]; then
				bat_status="!v"
			else
				bat_status="v";
			fi
			;;
		*) bat_status="=" ;;
		esac
		result+=" ${bat_status}${capacity}%%"
	done
	__battery_status="$result"
}
