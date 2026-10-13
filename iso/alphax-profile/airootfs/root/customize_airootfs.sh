#!/usr/bin/env bash
# ═══════════════════════════════════════════════════
# AlphaX Linux — Configuración del entorno Live (airootfs)
# ═══════════════════════════════════════════════════
set -euo pipefail

# Habilita servicios esenciales de escritorio y red
systemctl enable NetworkManager.service
systemctl enable seatd.service

# Crea grupos necesarios si no existen
for grp in wheel seat autologin video audio input storage games; do
    groupadd -f "$grp"
done

# Configura zsh como shell por defecto para root y bloquea login sin contraseña
chsh -s /usr/bin/zsh root
passwd -l root 2>/dev/null || true

# Crea usuario liveuser
if ! id -u liveuser >/dev/null 2>&1; then
    useradd -m -G wheel,seat,autologin,video,audio,input,storage,games -s /usr/bin/zsh liveuser
fi
echo "liveuser:liveuser" | chpasswd

# Permisos sudo para grupo wheel en archivo separado validado
mkdir -p /etc/sudoers.d
echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/10-alphax-live
chmod 440 /etc/sudoers.d/10-alphax-live

# Configura .zshrc con soporte tanto offline (plugins de sistema) como Oh-My-Zsh
cat > /etc/skel/.zshrc << 'ZSHRC'
export ZSH="$HOME/.oh-my-zsh"
if [ -f "$ZSH/oh-my-zsh.sh" ]; then
    ZSH_THEME="darkblood"
    plugins=(git archlinux sudo history colored-man-pages)
    source "$ZSH/oh-my-zsh.sh"
else
    PROMPT='%F{magenta}╭─[%F{cyan}%n%F{white}@%F{blue}AlphaX%F{magenta}]─[%F{white}%~%F{magenta}]
╰─➤ %f'
fi

# Plugins nativos de Arch Linux (funcionan 100% offline)
[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] && \
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share:/usr/share}:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share"
alias ll='ls -lah --color=auto'
alias update='sudo pacman -Syu && flatpak update -y'
alias aur='yay -S'
ZSHRC

# Asegurar permisos ejecutables en scripts de Codex WM y utilidades AlphaX
chmod +x /etc/skel/.config/codex/scripts/*.sh 2>/dev/null || true
chmod +x /usr/local/bin/alphax \
         /usr/local/bin/alphax-branding-apply \
         /usr/local/bin/codex-session \
         /usr/local/bin/alphax-firstrun.sh \
         /usr/local/bin/alphax-postinstall-cleanup.sh 2>/dev/null || true

# Aplicar identidad oficial de AlphaX Linux en /etc/os-release y /etc/lsb-release
/usr/local/bin/alphax-branding-apply

# Limpiar posibles archivos .pacnew generados durante pacstrap
find /etc -name "*.pacnew" -delete 2>/dev/null || true

# Copiar todo el esqueleto (/etc/skel) a liveuser y root
cp -rT /etc/skel /home/liveuser
cp /etc/skel/.zshrc /root/.zshrc
chown -R liveuser:liveuser /home/liveuser

echo "AlphaX live configurado correctamente ✓"