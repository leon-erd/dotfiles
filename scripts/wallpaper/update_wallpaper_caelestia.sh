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

# Set wallpaper
caelestia wallpaper -f $wallpaper