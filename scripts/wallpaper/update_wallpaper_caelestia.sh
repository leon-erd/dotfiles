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

# Set wallpaper
caelestia wallpaper -f $wallpaper