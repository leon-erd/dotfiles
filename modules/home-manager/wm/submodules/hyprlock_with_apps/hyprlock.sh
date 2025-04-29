#! /usr/bin/env bash

asciiquarium="alacritty -e asciiquarium -t"
cava="alacritty -o window.opacity=0 -e cava"
cmatrix="alacritty -o window.opacity=0 font.size=15 -e cmatrix -u 12 -C magenta"

pkill -USR1 waybar
hyprctl dispatch focusmonitor eDP-1
hyprctl dispatch workspace name:hyprlock
# hyprctl dispatch togglespecialworkspace hyprlock
hyprctl dispatch "exec [float; size 100% 100%; move 0 0] $asciiquarium"
hyprctl dispatch "exec [float; size 960 300; move 25% 100%-280] $cava"
# hyprctl dispatch "exec [float; size 20% 100%; move 0 0] $cmatrix"
# sleep 0.5
# hyprctl dispatch "exec [float; size 20% 100%; move 80% 0] $cmatrix"
hyprlock --immediate
pkill -f "$asciiquarium"
pkill -f "$cava"
# pkill -f "$cmatrix"
hyprctl dispatch workspace previous
pkill -USR1 waybar
