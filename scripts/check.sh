#!/usr/bin/env bash
# ═══════════════════════════════════════════════════
# AlphaX Linux — Validador de Integridad del Repositorio
# Funciona en cualquier distro (Void Linux, Arch, Ubuntu, CI)
# ═══════════════════════════════════════════════════
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "==> [1/6] Sincronizando codex-wm -> airootfs/etc/skel/.config/codex ..."
mkdir -p iso/alphax-profile/airootfs/etc/skel/.config/codex
cp -r codex-wm/* iso/alphax-profile/airootfs/etc/skel/.config/codex/
chmod +x codex-wm/scripts/*.sh \
         iso/alphax-profile/airootfs/etc/skel/.config/codex/scripts/*.sh \
         iso/alphax-profile/airootfs/usr/local/bin/alphax \
         iso/alphax-profile/airootfs/usr/local/bin/alphax-branding-apply \
         iso/alphax-profile/airootfs/usr/local/bin/codex-session \
         iso/alphax-profile/airootfs/usr/local/bin/alphax-firstrun.sh \
         iso/alphax-profile/airootfs/usr/local/bin/alphax-postinstall-cleanup.sh \
         iso/alphax-profile/airootfs/root/customize_airootfs.sh \
         installer/modules/post-install.sh

echo "==> [2/6] Verificando sintaxis Bash (bash -n) ..."
SCRIPTS=(
    codex-wm/scripts/gamemode-toggle.sh
    codex-wm/scripts/toggle-layout.sh
    codex-wm/scripts/wallpaper-picker.sh
    codex-wm/scripts/wifi-menu.sh
    installer/modules/post-install.sh
    iso/alphax-profile/profiledef.sh
    iso/alphax-profile/airootfs/root/customize_airootfs.sh
    iso/alphax-profile/airootfs/usr/local/bin/alphax
    iso/alphax-profile/airootfs/usr/local/bin/alphax-branding-apply
    iso/alphax-profile/airootfs/usr/local/bin/codex-session
    iso/alphax-profile/airootfs/usr/local/bin/alphax-firstrun.sh
    iso/alphax-profile/airootfs/usr/local/bin/alphax-postinstall-cleanup.sh
)
for script in "${SCRIPTS[@]}"; do
    bash -n "$script"
    echo "  ✓ $script"
done

if command -v shellcheck >/dev/null 2>&1; then
    echo "==> [2b/6] Ejecutando ShellCheck ..."
    shellcheck -S warning "${SCRIPTS[@]}"
    echo "  ✓ ShellCheck sin advertencias"
fi

echo "==> [3/6] Validando archivos JSON / JSONC (Waybar y Fastfetch) ..."
if command -v node >/dev/null 2>&1; then
    node -e '
      const fs = require("fs");
      for (const f of [
        "codex-wm/bar/config.jsonc",
        "iso/alphax-profile/airootfs/etc/skel/.config/codex/bar/config.jsonc",
        "iso/alphax-profile/airootfs/etc/skel/.config/fastfetch/config.jsonc"
      ]) {
        JSON.parse(fs.readFileSync(f, "utf8"));
        console.log("  ✓ " + f);
      }
    '
elif command -v python3 >/dev/null 2>&1; then
    python3 -c '
import json
for f in [
    "codex-wm/bar/config.jsonc",
    "iso/alphax-profile/airootfs/etc/skel/.config/codex/bar/config.jsonc",
    "iso/alphax-profile/airootfs/etc/skel/.config/fastfetch/config.jsonc"
]:
    with open(f) as fp:
        json.load(fp)
    print("  ✓ " + f)
'
fi

echo "==> [4/6] Verificando configuración de Hyprpaper ..."
grep -q '^preload =' codex-wm/config/hyprpaper.conf
grep -q '^wallpaper =' codex-wm/config/hyprpaper.conf
echo "  ✓ codex-wm/config/hyprpaper.conf válido"

echo "==> [5/6] Verificando lista de paquetes (packages.x86_64) ..."
awk '!/^#/ && NF > 0 {
    if (seen[$0]++) {
        print "  ✗ Paquete duplicado: " $0
        exit 1
    }
}
END {
    print "  ✓ " length(seen) " paquetes únicos sin duplicados"
}' iso/alphax-profile/packages.x86_64

REQUIRED_PKGS=(linux-zen linux-zen-headers plymouth zram-generator cpupower hyprland hyprpaper waybar rofi-wayland swaync libnotify ttf-jetbrains-mono-nerd networkmanager seatd calamares)
for pkg in "${REQUIRED_PKGS[@]}"; do
    if ! grep -Fxq "$pkg" iso/alphax-profile/packages.x86_64; then
        echo "  ✗ Falta paquete crítico en packages.x86_64: $pkg"
        exit 1
    fi
done
echo "  ✓ Todos los paquetes críticos de Kernel Zen, Plymouth, Codex WM e instalador están presentes"

echo "==> [5b/6] Verificando optimizaciones Gaming Low-Latency, Tema GRUB y Animación Plymouth ..."
GAMING_FILES=(
    iso/alphax-profile/airootfs/etc/sysctl.d/99-alphax-gaming.conf
    iso/alphax-profile/airootfs/etc/modules-load.d/99-alphax-gaming.conf
    iso/alphax-profile/airootfs/etc/systemd/zram-generator.conf
    iso/alphax-profile/airootfs/etc/security/limits.d/99-alphax-gaming.conf
    iso/alphax-profile/airootfs/etc/udev/rules.d/99-alphax-gaming.rules
    iso/alphax-profile/airootfs/etc/mkinitcpio.d/linux-zen.preset
    iso/alphax-profile/airootfs/etc/os-release
    iso/alphax-profile/airootfs/usr/local/bin/alphax-branding-apply
    iso/alphax-profile/airootfs/etc/pacman.d/hooks/90-alphax-branding.hook
    iso/alphax-profile/airootfs/etc/default/grub
    iso/alphax-profile/airootfs/usr/share/grub/themes/komeiji_koishi/theme.txt
    iso/alphax-profile/grub/themes/komeiji_koishi/theme.txt
    iso/alphax-profile/airootfs/usr/share/plymouth/themes/alphax/alphax.plymouth
    iso/alphax-profile/airootfs/usr/share/plymouth/themes/alphax/alphax.script
    iso/alphax-profile/airootfs/etc/plymouth/plymouthd.conf
)
for gf in "${GAMING_FILES[@]}"; do
    if [ ! -f "$gf" ]; then
        echo "  ✗ Falta archivo de optimización Gaming / Branding: $gf"
        exit 1
    fi
done
echo "  ✓ Optimizaciones Zen, BBR, SteamOS, Tema GRUB Komeiji Koishi y Animación Plymouth verificadas"

echo "==> [6/6] Verificando módulos de Calamares ..."
CALAMARES_FILES=(
    iso/alphax-profile/airootfs/etc/calamares/settings.conf
    iso/alphax-profile/airootfs/etc/calamares/modules/unpackfs.conf
    iso/alphax-profile/airootfs/etc/calamares/modules/netinstall.conf
    iso/alphax-profile/airootfs/etc/calamares/modules/netinstall.yaml
    iso/alphax-profile/airootfs/etc/calamares/modules/initcpio.conf
    iso/alphax-profile/airootfs/etc/calamares/modules/bootloader.conf
    iso/alphax-profile/airootfs/etc/calamares/modules/removeuser.conf
    iso/alphax-profile/airootfs/etc/calamares/modules/services-systemd.conf
    iso/alphax-profile/airootfs/etc/calamares/modules/shellprocess.conf
    iso/alphax-profile/airootfs/etc/calamares/modules/packages.conf
    iso/alphax-profile/airootfs/etc/calamares/modules/users.conf
    iso/alphax-profile/airootfs/etc/calamares/modules/welcome.conf
)
for cf in "${CALAMARES_FILES[@]}"; do
    if [ ! -f "$cf" ]; then
        echo "  ✗ Falta archivo de Calamares: $cf"
        exit 1
    fi
done
echo "  ✓ Todos los módulos de Calamares verificados"

echo ""
echo "✅ Todas las verificaciones de AlphaX Linux pasaron exitosamente."
