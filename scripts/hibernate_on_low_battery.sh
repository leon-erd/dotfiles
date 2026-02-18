#! /usr/bin/env bash

# richtige Laptop-Batterie finden
for bat in /sys/class/power_supply/BAT*; do
    if [[ -f "$bat/scope" ]]; then
        if grep -q "System" "$bat/scope"; then
            laptop_battery="$bat"
            break
        fi
    else
        laptop_battery="$bat"
        break
    fi
done

if [[ -z "$laptop_battery" ]]; then
    echo "Keine Laptop-Batterie gefunden!"
    exit 1
fi

echo "Using battery: $laptop_battery"

while true; do
    capacity=$(cat "$laptop_battery/capacity")
    status=$(cat "$laptop_battery/status")

    if [[ "$status" == "Discharging" && "$capacity" -lt 10 ]]; then
        notify-send --icon=battery-empty --urgency=critical \
            "Battery low" "Hibernating in 5 mins unless plugged"

        sleep 5m

        status=$(cat "$laptop_battery/status")
        if [[ "$status" == "Discharging" ]]; then
            systemctl hibernate
        fi
    fi

    sleep 60
done
