# AlphaX - Arranca Codex WM al entrar al live mode
if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
    exec codex-session
fi
