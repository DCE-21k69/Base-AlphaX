#!/bin/bash
# Toggle entre dwindle (tiling) y master (mosaico)
CURRENT=$(hyprctl getoption general:layout | grep -oP '(?<=str: )\w+')

if [ "$CURRENT" = "dwindle" ]; then
    hyprctl keyword general:layout master
    notify-send "Codex WM" "Modo: Mosaico 🪟" --icon=preferences-system-windows
else
    hyprctl keyword general:layout dwindle
    notify-send "Codex WM" "Modo: Tiling ▦" --icon=preferences-system-windows
fi
