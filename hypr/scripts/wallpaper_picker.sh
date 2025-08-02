#!/usr/bin/env bash
# Randomly sets hyprpaper wallpaper from a specified directory

hyprctl hyprpaper unload all

WALLPAPER_DIR=$HOME/Pictures/wallpapers/
CONFIG_FILE=$HOME/.config/hypr/hyprpaper.conf

CURRENT_WALL=$(hyprctl hyprpaper listactive | awk 'NR==1 {gsub(/[ =\n]/, "", $2); print $2}')

# Get a random wallpaper that is not the current one
WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

echo "preload = $WALLPAPER" > "$CONFIG_FILE"
echo "wallpaper = ,$WALLPAPER" >> "$CONFIG_FILE"

# Reload hyprpaper
pkill hyprpaper && hyprctl dispatch exec hyprpaper
