#!/usr/bin/env bash
# ═══════════════════════════════════════════════════
# AlphaX Linux — Primer arranque (Offline-safe)
# ═══════════════════════════════════════════════════
set -euo pipefail

# Solo intentar instalar Oh My Zsh si hay conexión real a Internet (timeout 3s)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    if curl -fsSL --connect-timeout 3 https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o /tmp/omz-install.sh 2>/dev/null; then
        sh /tmp/omz-install.sh --unattended --keep-zshrc || true
        rm -f /tmp/omz-install.sh
        echo "Oh My Zsh instalado ✓"
    fi
fi
