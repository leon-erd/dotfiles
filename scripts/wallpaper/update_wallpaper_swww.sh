#! /usr/bin/env bash

wallpaper_path="${XDG_CONFIG_HOME:-$HOME/.config}/myWallpaper/selected_image.txt"

# Read the path into a variable
if [[ -f "$wallpaper_path" ]]; then
    wallpaper="$(<"$wallpaper_path")"
    echo "The selected image is: $wallpaper"
else
    wallpaper="$(dirname "$(realpath "$0")")/wallpaper.jpg"
    echo "No image selected, using fallback: $wallpaper"
fi

# Get cursor pos
cursor_pos=$(hyprctl cursorpos -j)
x_coord=$(echo "$cursor_pos" | jq '.x')
y_coord=$(echo "$cursor_pos" | jq '.y')
x_coord=$((x_coord % 1920))

# Set wallpaper
swww img --transition-type grow --transition-pos "${x_coord}, ${y_coord}" --invert-y --transition-duration 1.5 --transition-fps 200 $wallpaper