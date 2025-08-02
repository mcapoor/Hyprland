#!/usr/bin/env bash
# Simple script to toggle AirPods connection using bluetoothctl with a keybind

device="2C:32:6A:DD:E2:39"

if bluetoothctl info "$device" | grep 'Connected: yes' -q; then
  bluetoothctl disconnect "$device"
else
  bluetoothctl connect "$device"
fi
