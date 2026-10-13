#!/usr/bin/env bash
# ═══════════════════════════════════════════════════
# AlphaX Linux — Script Opcional Post-Instalación (Chaotic-AUR & Extras)
# Uso manual opcional una vez instalado el sistema con conexión a Internet
# ═══════════════════════════════════════════════════
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
    echo "Ejecuta este script con sudo: sudo $0"
    exit 1
fi

echo "==> Configurando claves y mirrorlist de Chaotic-AUR..."
pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB
pacman -U --noconfirm \
    'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' \
    'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

if ! grep -q '^\[chaotic-aur\]' /etc/pacman.conf; then
    cat >> /etc/pacman.conf << 'EOF'

[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
EOF
fi

pacman -Sy --noconfirm yay paru
echo "Chaotic-AUR y AUR helpers (yay, paru) instalados ✓"
