#!/usr/bin/env bash
# ═══════════════════════════════════════════════════
# Codex WM — Wallpaper Picker (soporta espacios y persiste en hyprpaper.conf)
# ═══════════════════════════════════════════════════
set -euo pipefail

WALLPAPER_DIR="$HOME/.config/codex/wallpapers"
HYPRPAPER_CONF="$HOME/.config/codex/config/hyprpaper.conf"

if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send "Codex WM" "No existe el directorio $WALLPAPER_DIR" --icon=dialog-error
    exit 1
fi

mapfile -t WALLPAPERS < <(
    find "$WALLPAPER_DIR" -maxdepth 1 -type f \
        \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \) \
        -printf '%f\n' | sort
)

if [ "${#WALLPAPERS[@]}" -eq 0 ]; then
    notify-send "Codex WM" "No hay fondos en $WALLPAPER_DIR" --icon=dialog-information
    exit 0
fi

CHOSEN=$(printf '%s\n' "${WALLPAPERS[@]}" | rofi -dmenu -i \
    -p "󰸉  Wallpaper" \
    -theme-str 'window {width: 400px;}' \
    -no-custom || true)

[ -z "$CHOSEN" ] && exit 0

FULL_PATH="$WALLPAPER_DIR/$CHOSEN"
if [ ! -f "$FULL_PATH" ]; then
    notify-send "Codex WM" "El archivo seleccionado no es válido" --icon=dialog-error
    exit 1
fi

# Precargar y aplicar en vivo mediante hyprpaper IPC
hyprctl hyprpaper preload "$FULL_PATH" >/dev/null 2>&1 || true
hyprctl hyprpaper wallpaper ",$FULL_PATH" >/dev/null 2>&1 || true

# Persistir para el próximo inicio de sesión
mkdir -p "$(dirname "$HYPRPAPER_CONF")"
cat > "$HYPRPAPER_CONF" << EOF
# ═══════════════════════════════════════════════════
# Codex WM — Hyprpaper Configuration (AlphaX Linux)
# ═══════════════════════════════════════════════════

preload = $FULL_PATH
wallpaper = ,$FULL_PATH

splash = false
ipc = on
EOF

notify-send "Codex WM" "Wallpaper actualizado: $CHOSEN 󰸉" --icon=preferences-desktop-wallpaper
