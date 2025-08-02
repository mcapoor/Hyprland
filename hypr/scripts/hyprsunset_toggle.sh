#!/bin/bash
# Toggles the bluelight filter 

# Set the desired temperature (6500 is identity)
NORMAL_TEMP=6500
NORMAL_GAMMA=1.0

FILTER_TEMP=4500
FILTER_GAMMA=0.6

CURRENT_TEMP=$(hyprctl hyprsunset temperature)

if [[ "$CURRENT_TEMP" == "$FILTER_TEMP" ]]; then
    hyprctl hyprsunset temperature $NORMAL_TEMP gamma $NORMAL_GAMMA
else
    hyprctl hyprsunset temperature $FILTER_TEMP gamma $FILTER_GAMMA
fi