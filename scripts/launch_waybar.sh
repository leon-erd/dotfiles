#! /usr/bin/env bash

darken_factor=50 # percent
wal_css="$XDG_CACHE_HOME/wal/colors-waybar.css"

script_path="$(realpath "$0")"
wallpaper_path="$(dirname "$script_path")/wallpaper/wallpaper.jpg"

# Update color scheme
wal -c
wal -s -t -i "$wallpaper_path"

# make color1 darker
orig_color=$(grep '@define-color color1 ' "$wal_css" | awk '{print $3}')
darkened_color=$(printf "#%02x%02x%02x" \
    $(( (0x${orig_color:1:2} * (100 - darken_factor)) / 100 )) \
    $(( (0x${orig_color:3:2} * (100 - darken_factor)) / 100 )) \
    $(( (0x${orig_color:5:2} * (100 - darken_factor)) / 100 )))
sed -i "s|@define-color color1 .*|@define-color color1 $darkened_color;|" "$wal_css"

echo "Original color1: $orig_color"
echo "Darkened color1: $darkened_color"

# Update waybar
pkill waybar
waybar
