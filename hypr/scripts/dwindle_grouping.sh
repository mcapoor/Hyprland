#!/bin/bash
# Change grouping behavior for Hyprland so groups swallow dwindle children
# an keep focus on the active window
# Call with 'right', 'left', 'up', or 'down' as the first argument to choose the grouping direction

# TODO:
# - Implement horizontal_within-quarter grouping 
# - Add support for special workspaces


# Set this argument to true if you want left/right grouping to target only 
# windows within the same quarter of the screen (if they exist). If set to true
# and there are no windows in the same quarter, it will group all windows in the
# specified direction as normal.
HORIZONTAL_WITHIN_QUARTER=true 


# HELPER FUNCTIONS
window_quarter() {
    loc_x=$1
    loc_y=$2 

    if [[ $loc_x -lt $((monitor_width / 2)) ]]; then
        horizontal="left"
    else
        horizontal="right"
    fi

    if [[ $loc_y -lt $((monitor_width / 2)) ]]; then
        vertical="up"
    else
        vertical="down"
    fi

    echo "$horizontal $vertical"    
}

move() {
    local direction=$1
    local abbrev="${direction:0:1}"

    hyprctl dispatch focuswindow address:$address >> /dev/null
    echo "Moving $class at [$loc_x, $loc_y] $direction: $(hyprctl dispatch moveintogroup $abbrev)"
}

add_to_group() {
    local window=$1
    local group_direction=$2 

    address=$(echo $window | awk '{print $1}')
    loc=$(echo $window | awk '{print $2}')
    class=$(echo $window | awk '{print $3}')

    loc_x=$(echo $loc | cut -d'[' -f2 | cut -d',' -f1)
    loc_y=$(echo $loc | cut -d']' -f1 | cut -d',' -f2)

    width=$(echo $window | awk '{print $4}' | cut -d'[' -f2 | cut -d',' -f1)
    height=$(echo $window | awk '{print $4}' | cut -d']' -f2 | cut -d',' -f2)

    active_quarter=$(window_quarter $active_x $active_y)
    window_quarter=$(window_quarter $loc_x $loc_y)

    same_column=$([ "$(echo $active_quarter | awk '{print $1}')" = "$(echo $window_quarter | awk '{print $1}')" ] && echo true || echo false)
    same_row=$([ "$(echo $active_quarter | awk '{print $2}')" = "$(echo $window_quarter | awk '{print $2}')" ] && echo true || echo false)
s
    # Move other windows in the same column
    if [[ $group_direction = 'up' || $group_direction = 'down' ]]; then
        if [[ $loc_y -lt $active_y && $same_column = true ]]; then
            move "down"
        elif [[ $loc_y -gt $active_y && $same_column = true ]]; then
            move "up"
        else
            echo "$class not on same column as active"
        fi

    # Move other windows in the same row
    elif [[ $group_direction = 'right' || $group_direction = 'left' ]]; then
        
        if [[ $loc_x -lt $active_x && $same_row = true ]]; then
            echo "$class is left of active on the same row"
            move "right"

        elif [[ $loc_x -gt $active_x && $same_row = true ]]; then
            echo "$class is right of active on the same row"
            move "left"
        else
            echo "$class is not on same row"
        fi        
        
    # Catch command syntax error
    else
        echo "Invalid group direction: $group_direction"
        exit 1
    fi
}

# MAIN SCRIPT
group_direction=${1:-down} # set default to 'down' if no argument is provided (for debugging)

monitor_width=$(hyprctl monitors -j | jq -r '
                .[] 
                | select(.focused)
                | .width') 

focused_ws=$(hyprctl activeworkspace -j | jq '.id')

active_addr=$(hyprctl activewindow -j | jq -r '.address')
active_loc=$(hyprctl activewindow -j | jq -r '.at' | tr -d ',')

active_x=$(awk 'NR==2 {print $1}' <<< "$active_loc")
active_y=$(awk 'NR==3 {print $1}' <<< "$active_loc")

active_width=$(hyprctl activewindow -j | jq -r '.size[0]')
active_height=$(hyprctl activewindow -j | jq -r '.size[1]')

grouped=$(hyprctl activewindow -j | jq -r '.grouped')

#Toggle group if it doesn't exist
if [[ $grouped == "[]" ]]; then
    echo -e "Enabling group at [$active_x, $active_y]: $(hyprctl dispatch togglegroup "$active_window")\n"
else 
    echo -e "Group found at [$active_x, $active_y]\n"
fi

# Get all windows in the focused workspace that are not the active window
windows=$(hyprctl clients -j \
    | jq -r --argjson id "$focused_ws" --arg active "$active_addr" '
        .[] 
        | select(.workspace.id == $id)
        | select(.address != $active) 
        | select(.grouped | index($active) | not)
        | select(.floating == false)
        | select(.pinned == false)
        | "\(.address) \(.at) \(.class) \(.size)"')
    
    
while IFS= read -r window; do
    add_to_group "$window" "$group_direction"
done <<< "$windows"

echo -e "\nRefocusing active window: $(hyprctl dispatch focuswindow address:$active_addr)"


