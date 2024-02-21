#! /usr/bin/env bash

script_path="$(realpath "$0")"
wallpaper_path="$(dirname "$script_path")/wallpaper/wallpaper.jpg"

# Update color scheme
wal -c
wal -s -t -i $wallpaper_path

# Update waybar
pkill waybar
waybar
