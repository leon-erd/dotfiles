#! /usr/bin/env bash

wallpaper_path="${XDG_CONFIG_HOME:-$HOME/.config}/myWallpaper/selected_image.txt"
fallback_wallpaper=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --fallback)
      fallback_wallpaper="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
  esac
done

# Read the path into a variable
if [[ -f "$wallpaper_path" ]]; then
    wallpaper="$(<"$wallpaper_path")"
    echo "The selected image is: $wallpaper"
else
    wallpaper="$fallback_wallpaper"
    echo "No image selected, using fallback: $wallpaper"
fi

# Get cursor pos
cursor_pos=$(hyprctl cursorpos -j)
x_coord=$(echo "$cursor_pos" | jq '.x')
y_coord=$(echo "$cursor_pos" | jq '.y')
x_coord=$((x_coord % 1920))

# Set wallpaper
swww img --transition-type grow --transition-pos "${x_coord}, ${y_coord}" --invert-y --transition-duration 1.5 --transition-fps 200 $wallpaper