#!/bin/bash
# Info popup for Hyprland windows on the focused workspace

focused_workspace=$(hyprctl activeworkspace -j | jq '.id')

# Get clients on that workspace and loop through each one
hyprctl clients -j | jq -c --argjson id "$focused_workspace" '.[] | select(.workspace.id == $id)' |
while IFS= read -r window; do
    yad_rows=()

    # Format each key-value pair for yad list view
    while IFS=$'\t' read -r key value; do
        yad_rows+=("$key" "$value")
    done < <(
        echo "$window" |
        jq -r 'to_entries[] | "\(.key)\t\(.value|tostring)"'
    )

    # Place the popup in the center of the window
    locs=$(echo "$window" | jq -r '.at[]' | xargs)
    dims=$(echo "$window" | jq -r '.size[]' | xargs)

    read loc_x loc_y <<< "$locs"
    read dim_w dim_h <<< "$dims"

    yad_h=400
    yad_w=400

    pos_x=$((loc_x + dim_w / 2 - yad_w / 2))
    pos_y=$((loc_y + dim_h / 2 - yad_h / 2))

    # Offsets the position if multiple windows are at the same location (for groups)
    declare -A used_positions

    pos_key="${pos_x}_${pos_y}"

    if [[ -n "${used_positions[$pos_key]}" ]]; then
        count=${used_positions[$pos_key]}
        offset=$((count * 30)) 
        pos_x=$((pos_x + offset))
        pos_y=$((pos_y + offset))
        used_positions[$pos_key]=$((count + 1))
    else
        used_positions[$pos_key]=1
    fi

    GDK_BACKEND=x11 GTK_THEME=diinki-retro-dark yad --list \
        --title="Client Info: $(echo "$window" | jq -r '.class')" \
        --column="Key" --column="Value" \
        --width="$yad_w" --height="$yad_h" \
        --posx="$pos_x" --posy="$pos_y" \
        --no-buttons \
        "${yad_rows[@]}" &
done