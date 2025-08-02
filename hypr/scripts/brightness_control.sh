#!/bin/bash
# Wrapper for brightness control to send notifications
# Call with 'raise' or 'lower' as the first argument

ICON=''

if [[ $1 == 'raise' ]]; then 
    brightnessctl s +5%
elif [[ $1 == 'lower' ]]; then
    brightnessctl s 5%-
else 
    echo "Unknown option: $1"
fi

IFS=, read -a ARR <<< "$(brightnessctl -m)"
BRIGHTNESS="${ARR[3]}"
echo $BRIGHTNESS

hyprctl dismissnotify && hyprctl notify -1 1500 0 "fontsize:16 $ICON  $BRIGHTNESS"