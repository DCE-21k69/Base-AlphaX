#!/usr/bin/env bash
# ═══════════════════════════════════════════════════
# Codex WM — Toggle entre Dwindle (Tiling) y Master (Mosaico)
# ═══════════════════════════════════════════════════
set -euo pipefail

CURRENT=$(hyprctl getoption general:layout 2>/dev/null | awk '/str:/ {print $2}')

if [ "$CURRENT" = "dwindle" ]; then
    hyprctl keyword general:layout master
    notify-send "Codex WM" "Modo: Mosaico 🪟" --icon=preferences-system-windows
else
    hyprctl keyword general:layout dwindle
    notify-send "Codex WM" "Modo: Tiling ▦" --icon=preferences-system-windows
fi
