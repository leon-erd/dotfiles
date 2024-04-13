#! /usr/bin/env bash

hyprctl dispatch focusmonitor eDP-1
pkill -USR1 waybar
swww img -o eDP-1 scripts/wallpaper/wallpaper_blurred.jpg
hyprctl dispatch "exec [workspace name:hyprlock; monitor:eDP-1; float; size 960 300; move 25% 100%-280; noblur; noborder; noshadow; nodim] alacritty -o window.opacity=0 -e cava"
hyprlock --immediate
pkill -f "alacritty -o window.opacity=0 -e cava"
swww img -o eDP-1 scripts/wallpaper/wallpaper.jpg
pkill -USR1 waybar
hyprctl dispatch workspace previous
