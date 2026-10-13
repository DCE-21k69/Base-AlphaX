# AlphaX Linux — Arranca Codex WM automáticamente en TTY1 (Bash login shell)
if [ -z "${WAYLAND_DISPLAY:-}" ] && [ "${XDG_VTNR:-0}" -eq 1 ]; then
    exec /usr/local/bin/codex-session
fi
