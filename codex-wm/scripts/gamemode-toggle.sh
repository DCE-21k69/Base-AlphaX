#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════
# Codex WM — Modo Competitivo Zero-Lag (SUPER + G)
# Desactiva blur, sombras, gaps y animaciones para 0 input lag y máximo FPS
# ═══════════════════════════════════════════════════════════════════
set -euo pipefail

STATE_FILE="/tmp/codex-gamemode.lock"

if [ "${1:-toggle}" = "status" ]; then
    if [ -f "$STATE_FILE" ]; then
        echo "⚡ Zero-Lag"
    else
        echo "󰊴 Normal"
    fi
    exit 0
fi

if [ ! -f "$STATE_FILE" ]; then
    # Activar Modo Competitivo Zero-Lag
    touch "$STATE_FILE"
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:blur:enabled 0;\
        keyword decoration:shadow:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0;\
        keyword general:allow_tearing 1" >/dev/null 2>&1 || true

    # Silenciar notificaciones emergentes durante la partida
    command -v swaync-client >/dev/null 2>&1 && swaync-client -dn >/dev/null 2>&1 || true

    # Intentar poner CPU en modo performance si tiene permisos sudo sin clave
    sudo -n cpupower frequency-set -g performance >/dev/null 2>&1 || true

    notify-send "Codex WM" "⚡ Modo Competitivo ZERO-LAG Activado" --icon=input-gaming
else
    # Restaurar Modo Normal Tokyo Night
    rm -f "$STATE_FILE"
    hyprctl reload >/dev/null 2>&1 || true

    # Reactivar notificaciones
    command -v swaync-client >/dev/null 2>&1 && swaync-client -df >/dev/null 2>&1 || true

    notify-send "Codex WM" "󰊴 Modo Normal (Tokyo Night) Restaurado" --icon=preferences-desktop-theme
fi
