#!/bin/bash
# Wrapper for volume control to send notifications
# Call with 'mute', 'raise', or 'lower' as the first argument

if [[ "$1" == "mute" ]]; then
    pactl set-sink-mute @DEFAULT_SINK@ toggle

    if pactl get-sink-mute @DEFAULT_SINK@ | grep -q "yes"; then
        ICON=""
    else
        ICON=""
    fi

elif [[ "$1" == "raise" ]]; then
   ICON=""
   pactl set-sink-mute @DEFAULT_SINK@ false && pactl set-sink-volume @DEFAULT_SINK@ +5%


elif [[ "$1" == "lower" ]]; then
    ICON=""
    pactl set-sink-mute @DEFAULT_SINK@ false && pactl set-sink-volume @DEFAULT_SINK@ -5%
fi

# Send notification of volume change
hyprctl dismissnotify && hyprctl notify -1 1500 0 "fontsize:16 $ICON   $(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | sed 's/%//')%"
