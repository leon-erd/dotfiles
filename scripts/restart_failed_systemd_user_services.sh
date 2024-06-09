#!/usr/bin/env bash

# List all user services that are in a failed state and restart them
failed_services=$(systemctl --user list-units --type=service --state=failed | grep failed | awk '{print $2}')

if [ -n "$failed_services" ]; then
    for service in $failed_services; do
        systemctl --user restart "$service"
    done
    notify-send "Systemd restart script" "Restarted the following failed user services: \n$failed_services"
    echo "Restarted the following failed user services: \n$failed_services"
fi
