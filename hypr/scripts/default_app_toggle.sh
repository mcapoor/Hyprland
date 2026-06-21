# !/bin/bash
# Switches focus to default applications if they are running on the workspace, otherwise launches them

application=$1

focused_ws=$(hyprctl activeworkspace -j | jq '.id')

# Get all windows in the focused workspace that are not the active window
windows_on_ws=$(hyprctl clients -j | jq -r --argjson ws "$focused_ws" '
  .[]
  | select(.workspace.id == $ws)
  | "\(.address) \(.class)"
')
echo "Windows on focused workspace ($focused_ws):"
echo "$windows_on_ws"

if [[ $application == 'gtk-launch firefox_work' ]]; then
    class='firefox'
elif [[ $application == 'nemo' ]]; then
    class='nemo'
elif [[ $application == 'okular' ]]; then
    class='okular'
elif [[ $application == 'code' ]]; then
    class='code'
elif [[ $application == 'kitty' ]]; then
    class='kitty'
else
    echo "Application not recognized. Trying to launch it directly."
    $application &
fi
 
if echo "$windows_on_ws" | grep -q "$class"; then
    window_address=$(echo "$windows_on_ws" | grep "$class" | awk '{print $1}')
    echo "Focusing on running $application with address $window_address"
    hyprctl dispatch focuswindow address:$window_address
else
    echo "$application not running on this workspace. Launching it."
    $application &
fi