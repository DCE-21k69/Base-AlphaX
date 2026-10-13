#!/usr/bin/env bash
# ═══════════════════════════════════════════════════
# AlphaX Linux — Limpieza Post-Instalación (Calamares Target)
# ═══════════════════════════════════════════════════
set -euo pipefail

# 1. Eliminar hooks y presets exclusivos del modo Live (archiso)
rm -f /etc/mkinitcpio.conf.d/archiso.conf
rm -f /etc/systemd/system/getty@tty1.service.d/autologin.conf
rm -f /etc/systemd/system/etc-pacman.d-gnupg.mount
rm -f /etc/systemd/system/choose-mirror.service
rm -f /etc/systemd/system/pacman-init.service
rm -f /etc/systemd/system/livecd-alsa-unmuter.service
rm -f /etc/systemd/system/livecd-talk.service
rm -f /etc/systemd/system/multi-user.target.wants/choose-mirror.service
rm -f /etc/systemd/system/multi-user.target.wants/pacman-init.service
rm -f /etc/systemd/system/sound.target.wants/livecd-alsa-unmuter.service
rm -f /etc/skel/.config/autostart/calamares.desktop
rm -f /usr/share/applications/calamares-alphax.desktop
rm -f /root/customize_airootfs.sh /root/.automated_script.sh

# 2. Restaurar preset estándar de mkinitcpio y activar hook Plymouth para disco duro (Kernel Linux-Zen)
rm -f /etc/mkinitcpio.d/linux.preset
mkdir -p /etc/mkinitcpio.conf.d
cat > /etc/mkinitcpio.conf.d/10-alphax-plymouth.conf << 'EOF'
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont plymouth block filesystems fsck)
EOF

cat > /etc/mkinitcpio.d/linux-zen.preset << 'EOF'
ALL_kver="/boot/vmlinuz-linux-zen"
PRESETS=('default' 'fallback')
default_image="/boot/initramfs-linux-zen.img"
fallback_image="/boot/initramfs-linux-zen-fallback.img"
fallback_options="-S autodetect"
EOF

# 3. Reemplazar sudo NOPASSWD del Live USB por sudo estándar con contraseña para el grupo wheel
rm -f /etc/sudoers.d/10-alphax-live
mkdir -p /etc/sudoers.d
echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers.d/10-alphax-wheel
chmod 440 /etc/sudoers.d/10-alphax-wheel

# 4. Asegurar que todos los usuarios creados tengan Zsh y las configs de Codex WM
for user_home in /home/*; do
    [ -d "$user_home" ] || continue
    username="$(basename "$user_home")"
    [ "$username" = "liveuser" ] && continue
    if id "$username" >/dev/null 2>&1; then
        chsh -s /usr/bin/zsh "$username" || true
        cp -rn /etc/skel/. "$user_home/" 2>/dev/null || true
        rm -f "$user_home/.config/autostart/calamares.desktop"
        chmod +x "$user_home/.config/codex/scripts/"*.sh 2>/dev/null || true
        chown -R "$username:$username" "$user_home"
    fi
done

echo "AlphaX Linux post-instalación completada ✓"
