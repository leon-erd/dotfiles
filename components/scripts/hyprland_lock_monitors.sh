#! /usr/bin/env bash

# Get monitor data as JSON and sort by x position
monitors=$(hyprctl monitors -j | jq 'sort_by(.x)')

# Parse monitor info into arrays (using mapfile)
mapfile -t xs < <(echo "$monitors" | jq '.[].x')
mapfile -t names < <(echo "$monitors" | jq -r '.[].name')
mapfile -t widths < <(echo "$monitors" | jq '.[].width')
mapfile -t heights < <(echo "$monitors" | jq '.[].height')
mapfile -t refreshs < <(echo "$monitors" | jq '.[].refreshRate')

# Check for gaps
has_gap=false
for ((i=1; i<${#xs[@]}; i++)); do
    expected_x=$(( xs[i-1] + widths[i-1] ))
    if [[ ${xs[i]} -ne $expected_x ]]; then
        has_gap=true
        break
    fi
done

if $has_gap; then
    # Remove gaps: set each monitor's x to previous x + width
    new_x=0
    for ((i=0; i<${#names[@]}; i++)); do
        hyprctl keyword monitor "${names[i]},${widths[i]}x${heights[i]}@${refreshs[i]},${new_x}x0"
        new_x=$(( new_x + widths[i] ))
    done
    echo "Gaps removed."
else
    # Add 1000px gaps between monitors
    new_x=0
    for ((i=0; i<${#names[@]}; i++)); do
        hyprctl keyword monitor "${names[i]},${widths[i]}x${heights[i]}@${refreshs[i]},${new_x}x0"
        new_x=$(( new_x + widths[i] + 1000 ))
    done
    echo "Gaps of 1000px added."
fi