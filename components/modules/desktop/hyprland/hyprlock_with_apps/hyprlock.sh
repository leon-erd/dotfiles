#! /usr/bin/env bash

window_rules="monitor:eDP-1; float; decorate:false; noborder; noshadow; noanim"
asciiquarium="alacritty -e asciiquarium -t"
cava="alacritty -o window.opacity=0 -e cava"
cmatrix="alacritty -o window.opacity=0 font.size=15 -e cmatrix -u 12 -C magenta"

pkill -USR1 waybar
hyprctl dispatch focusmonitor eDP-1
# hyprctl dispatch workspace name:hyprlock
# hyprctl dispatch togglespecialworkspace hyprlock
hyprctl dispatch "exec [$window_rules; size 100% 100%; move 0 0] $asciiquarium"
sleep 0.1
hyprctl dispatch "exec [$window_rules; size 1630 250; move 0% 100%-230; noblur] $cava"
# hyprctl dispatch "exec [$window_rules; size 20% 100%; move 0 0] $cmatrix"
# sleep 0.5
# hyprctl dispatch "exec [$window_rules; size 20% 100%; move 80% 0] $cmatrix"
hyprlock --immediate
pkill -f "$asciiquarium"
pkill -f "$cava"
# pkill -f "$cmatrix"
# hyprctl dispatch workspace previous
pkill -USR1 waybar
