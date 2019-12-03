__battery () {
	__battery_status=''
	local bat batfull batwarn batnow num batsign
	for num in 0 1 ; do
		bat=$(sysctl -n hw.sensors.acpibat${num} 2>/dev/null)
		if [ -z "$bat" ]; then
			continue
		fi
		batfull=${"$(sysctl -n hw.sensors.acpibat${num}.amphour0)"%% *}
		batwarn=${"$(sysctl -n hw.sensors.acpibat${num}.amphour1)"%% *}
		batnow=${"$(sysctl -n hw.sensors.acpibat${num}.amphour3)"%% *}
		capacity=$(( 100 * $energy_now / $energy_full))
		case "$(sysctl -n hw.sensors.acpibat${num}.raw0)" in
			*discharging*)
				if (( batnow < batwarn )) ; then
					batsign="!v"
				else
					batsign="v"
				fi
				;;
			*charging*)
				batsign="^" ;;
			*)
				batsign="=" ;;
		esac
		__battery_status+=" ${batsign}${$(( 100 * batnow / batfull ))%%.*}%%"
	done
}
