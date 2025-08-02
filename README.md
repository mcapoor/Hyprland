# My Hyprland Configuration

## Main config files

* Main config: `hypr/hyprland.conf`
* Keybindings: `hypr/binds.conf`
* Window rules: `hypr/windows.conf`
* Design (almost entirely [Diinki's](https://github.com/diinki/diinki-retrofuture)): `hypr/theming.conf`

## Hyprland ecosystem configs

* Hyprlock: `hypr/hyprlock.conf`
* Hypridle: `hypr/hypridle.conf`
* Hyprpaper: `hypr/hyprpaper.conf`
* Hyprsunset: `hypr/hyprsunset.conf`
* Hyprsession: `hypr/hyprsession.conf`

* Waybar: `waybar/config` and `waybar/style.css`
* Wofi: `wofi/config` and `wofi/style.css`

## Miscellaneous config

* Fish shell stuff: `fish/config.fish`
* Kitty terminal: `kitty/kitty.conf`, `diinki_retro.conf` (theme), and `launch.conf` (attaches tmux)
* Neofetch: `fastfetch/config.jsonc` and `hyfetch.json`

## My Scripts

The little ones:

* To quickly connect/disconnect my Airpods: `hypr/scripts/airpod_toggle.sh`
* Notification wrappers for brightness and volume: `hypr/scripts/brightness_control.sh` and `hypr/scripts/volume_control.sh`
* To toggle Hyprsunset with Waybar: `hypr/scripts/hyprsunset_toggle.sh`
* To show battery info on Hyprlock: `hypr/scripts/hyprlock_battery.sh`
* To randomly select a wallpaper: `hypr/scripts/wallpaper_picker.sh`
* To maintain a list of apps that need to be downgraded to avoid issues: `hypr/scripts/downgrade_packages.sh`
* To manually refresh Waybar: `waybar/waybar_refresh.sh`

The really useful ones:

* To switch between open applications: `hypr/scripts/app_finder.py`
* A rewrite of Hyprland's grouping behavior to keep focus on the first toggled window and swallow other windows in the workspace: `hypr/scripts/dwindle_grouping.sh`
* Popups that show `hyprctl clients` info for each window in the focused workspace: `hypr/scripts/window_info_popup.sh`
