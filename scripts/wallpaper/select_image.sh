#! /usr/bin/env bash

img_folder="$HOME/Nextcloud/Pictures/Geordnet"

# Extract the directory part of the script
script_path="$(realpath "$0")"
script_directory="$(dirname "$script_path")"

# Path to the file where we save the selected image
output_file="$script_directory/selected_image.txt"

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
            echo "$random_image" | tee "$output_file"
            break
        fi
    fi
done