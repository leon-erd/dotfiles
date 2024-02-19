#! /usr/bin/env bash

#https://wiki.archlinux.org/title/laptop#hibernate_on_low_battery_level

while true; do
	# Run acpi -b and grep for the line containing "Discharging"
	discharging_info=$(acpi -b | grep "Discharging")

	# Check if the line contains "Discharging"
	if [[ -n "$discharging_info" ]]; then
		# Extract capacity using awk
		capacity=$(echo "$discharging_info" | awk -F'[,:%]' '{print $3}')

		if [ "$capacity" -lt 10 ]; then
			notify-send --icon=battery-empty --urgency=Critical "Battery low" "Hibernating in 5 mins unless plugged"
			sleep 5m

			discharging_info=$(acpi -b | grep "Discharging")
			if [[ -n "$discharging_info" ]]; then
				systemctl hibernate
			fi
		fi

	fi
	sleep 60
done
