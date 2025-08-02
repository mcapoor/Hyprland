#!/usr/bin/env python3
# Script to list and focus open applications in Hyprland using wofi
# Taken from joelxr (Dec 5, 2023) on https://github.com/hyprwm/Hyprland/discussions/830

import gi
import sys
import os
import json
import re

gi.require_version('Gtk', '3.0')
from gi.repository import Gtk

def resolveIconPath(iconName):
    iconTheme = Gtk.IconTheme.get_default()
    iconFile = iconTheme.lookup_icon(iconName.lower(), 32, 0)

    if iconFile:
        return iconFile.get_filename()
    else:
        return ""

def mapWindow(w):
    return f"img:{resolveIconPath(w['class'])}:text:{w['title']} ({w['class']} - {w['address']}_{w['workspace']['id']})"

windows = json.loads(os.popen("hyprctl -j clients").read())
filtered_windows = list(filter(lambda w: w["workspace"]["id"] != -1, windows))
mapped_windows = list(map(mapWindow, filtered_windows))

selected_window = os.popen(f"echo \"{'\n'.join(mapped_windows)}\" | wofi -I --width 50% -p 'Search open applications...' -S dmenu").read()

print(f"selected_window: {selected_window}")

if (selected_window):
    match = re.search(r"(- [\w-]+)\)$", selected_window)
    print(f"match: {match}")
    addr = match.group(1).split("- ")[1].split("_")[0]
    print(f"addr: {addr}")
    os.system(f"hyprctl dispatch focuswindow address:{addr}")
else:
    print("no selected_window")