#! /usr/bin/env bash

img_folder="$HOME/Nextcloud/Pictures/Geordnet"

# Extract the directory part of the script
script_path="$(realpath "$0")"
script_directory="$(dirname "$script_path")"
parent_directory="$(dirname "$script_directory")"

# get random horizontal image
while true; do
    # pick random image
    random_image=$(find "$img_folder" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.heic" \) | shuf -n 1)

    # check if image is horizontal
    if [[ -n "$random_image" ]]; then

        # get image dimensions using identify command (from ImageMagick)
        dimensions=$(magick identify -format "%w %h" "$random_image" 2>/dev/null)
        [[ -z "$dimensions" ]] && continue

        # make sure the image is not supposed to be viewed in a different orientation
        orientation=$(magick identify -format "%[EXIF:Orientation]" "$random_image" 2>/dev/null)
        [[ -z "$orientation" ]] && orientation=1

        read -r width height <<< "$dimensions"
        
        if (( width > height )) && [[ "$orientation" -eq 1 ]]; then
            echo "$random_image"
            break
        fi
    fi
done

# Copy the image to the script directory
ffmpeg -y -i "$random_image" $script_directory/wallpaper.jpg

# Get cursor pos
cursor_pos=$(hyprctl cursorpos)
read -r x_coord y_coord <<< "$cursor_pos"

# Set wallpaper
swww img --transition-type grow --transition-pos "${x_coord}${y_coord}" --invert-y --transition-duration 1.5 --transition-fps 200 $script_directory/wallpaper.jpg

# Update waybar
$parent_directory/launch_waybar.sh

# create blurred image for grub wallpaper
ffmpeg -y -i $script_directory/wallpaper.jpg -vf "boxblur=15:5" -pix_fmt yuvj420p $script_directory/wallpaper_blurred.jpg
