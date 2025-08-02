#!/bin/bash
# Kill and restart waybar whenever its config files change

CONFIG_FILES="$HOME/.config/waybar/config $HOME/.config/waybar/style.css"

trap "killall waybar" EXIT

while true; do
    waybar &
    inotifywait -e modify ${CONFIG_FILES} 2>&1 | logger -i
    killall waybar 2>&1 | logger -i
    sleep 1
done