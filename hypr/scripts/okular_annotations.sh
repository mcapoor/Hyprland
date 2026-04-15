#!/bin/bash 
# Checks if Okular is open and maps mouse side buttons to highlighter annotations

class=$(hyprctl activewindow -j | jq -r '.class')

echo $class 

if [[ $class == 'org.kde.okular' ]]; then 
    echo "Sending $1 to okular..." 
    hyprctl dispatch sendshortcut ", $1", activewindow
else 
    echo "Okular not active. Exiting..." 
fi 