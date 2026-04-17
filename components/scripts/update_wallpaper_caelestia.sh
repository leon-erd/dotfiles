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

# Set wallpaper
caelestia wallpaper -f "$wallpaper"