#!/bin/bash
# Codex Wallpaper Picker
WALLPAPER_DIR="$HOME/.config/codex/wallpapers"

# Lista wallpapers disponibles
CHOSEN=$(ls "$WALLPAPER_DIR" | rofi -dmenu \
    -p "󰸉  Wallpaper" \
    -theme-str 'window {width: 400px;}')

[ -z "$CHOSEN" ] && exit

# Aplica el wallpaper
hyprctl hyprpaper wallpaper ",$WALLPAPER_DIR/$CHOSEN"

# Guarda como default para próximo arranque
sed -i "s|wallpaper = .*|wallpaper = ,$WALLPAPER_DIR/$CHOSEN|" \
    "$HOME/.config/codex/config/hyprpaper.conf"

notify-send "Codex WM" "Wallpaper cambiado 󰸉" --icon=preferences-desktop-wallpaper
