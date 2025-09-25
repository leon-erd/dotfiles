#! /usr/bin/env bash

# Extract the directory part of the script
script_path="$(realpath "$0")"
script_directory="$(dirname "$script_path")"
wallpaper_path="$script_directory/selected_image.txt"

# Read the path into a variable
if [[ -f "$wallpaper_path" ]]; then
    wallpaper="$(<"$wallpaper_path")"
    echo "The selected image is: $wallpaper"
else
    echo "No image has been selected yet."
fi

# Get cursor pos
cursor_pos=$(hyprctl cursorpos -j)
x_coord=$(echo "$cursor_pos" | jq '.x')
y_coord=$(echo "$cursor_pos" | jq '.y')
x_coord=$((x_coord % 1920))

# Set wallpaper
swww img --transition-type grow --transition-pos "${x_coord}, ${y_coord}" --invert-y --transition-duration 1.5 --transition-fps 200 $wallpaper