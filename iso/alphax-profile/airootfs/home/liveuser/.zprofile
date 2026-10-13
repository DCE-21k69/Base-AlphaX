# AlphaX Linux — Arranca Codex WM al entrar al modo Live (Zsh)
if [ -z "${WAYLAND_DISPLAY:-}" ] && [ "${XDG_VTNR:-0}" -eq 1 ]; then
    exec /usr/local/bin/codex-session
fi
