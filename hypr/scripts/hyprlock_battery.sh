#!/bin/bash
# Battery status script for Hyprlock 
# Taken from ashish_kus https://gist.github.com/ashish-kus/dd562b0bf5e8488a09e0b9c289f4574c

battery_percentage=$(cat /sys/class/power_supply/BAT0/capacity)
battery_status=$(cat /sys/class/power_supply/BAT0/status)

battery_icons=("󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰁹")
charging_icon="󰂄"

icon_index=$((battery_percentage / 10))
battery_icon=${battery_icons[icon_index - 1]}

if [ "$battery_status" = "Charging" ]; then
	battery_icon="$charging_icon"
fi

echo "$battery_percentage% $battery_icon"