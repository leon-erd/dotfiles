#! /usr/bin/env bash

category=universe

# Extract the directory part of the script
script_path="$(realpath "$0")"
script_directory="$(dirname "$script_path")"
parent_directory="$(dirname "$script_directory")"

# Download wallpaper
wget --output-document=$script_directory/wallpaper.jpg https://source.unsplash.com/1920x1080/?$category

# Get cursor pos
cursor_pos=$(hyprctl cursorpos)
read -r x_coord y_coord <<< "$cursor_pos"
y_coord=$((1080-$y_coord))

# Set wallpaper
swww img --transition-type grow --transition-pos "${x_coord}${y_coord}" $script_directory/wallpaper.jpg

# Update waybar
$parent_directory/launch_waybar.sh

ffmpeg -y -i $script_directory/wallpaper.jpg $script_directory/wallpaper.png

ffmpeg -y -i $script_directory/wallpaper.jpg -vf "boxblur=15:5" $script_directory/wallpaper_blurred.jpg
