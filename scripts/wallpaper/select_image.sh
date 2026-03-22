#! /usr/bin/env bash

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <img_folder>" >&2
    exit 1
fi

img_folder="$1"
output_file="${XDG_CONFIG_HOME:-$HOME/.config}/myWallpaper/selected_image.txt"

mkdir -p "$(dirname "$output_file")"

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