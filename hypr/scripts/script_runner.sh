#!/bin/bash 
# Launcher for scripts not used often enough to be a keybind. Also useful for testing new scripts as they are run in a terminal.

# Ensure Wayland env is explicitly available
export GDK_BACKEND=wayland
export WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-wayland-0}

# Define directories to search for scripts
SCRIPT_DIR=("$HOME/scripts" "$HOME/.config/hypr/scripts")

launch_script() {
    local selected="$1"
    local extension="${selected##*.}"

    if [[ "$extension" = "sh" || "$extension" = "bash" ]]; then
        kitty -e bash "$selected"
    elif [[ "$extension" = "py" ]]; then
        kitty -e python "$full_path"
    else
        echo "Script runner: Unknown extension: $extension"
    fi
}

SCRIPT=$(find "${SCRIPT_DIR[@]}" -name "*.*" ! -name  "*.png" \
 | wofi -I --show dmenu --prompt "Select a script to run:" --width 40% --lines 10)

echo $SCRIPT

launch_script "$SCRIPT"

