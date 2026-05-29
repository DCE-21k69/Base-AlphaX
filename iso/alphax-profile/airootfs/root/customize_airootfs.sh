#!/bin/bash
set -e

# Habilita servicios
systemctl enable NetworkManager
systemctl enable seatd

# Crea grupo seat manualmente si no existe
groupadd -f seat
groupadd -f autologin

# Configura zsh como shell por defecto
chsh -s /usr/bin/zsh root

# Crea usuario live
useradd -m -G wheel,seat,video,audio,input,storage,games liveuser 2>/dev/null || true
echo "liveuser:liveuser" | chpasswd
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Cambia shell de liveuser a zsh
chsh -s /usr/bin/zsh liveuser

# Copia nuestro zshrc
cat > /etc/skel/.zshrc << 'ZSHRC'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="darkblood"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting archlinux sudo history colored-man-pages)
source $ZSH/oh-my-zsh.sh 2>/dev/null || true
export XDG_DATA_DIRS=$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:~/.local/share/flatpak/exports/share
alias ll='ls -lah'
alias update='sudo pacman -Syu && flatpak update -y'
alias aur='yay -S'
ZSHRC

cp /etc/skel/.zshrc /home/liveuser/.zshrc
cp /etc/skel/.zshrc /root/.zshrc
chown liveuser:liveuser /home/liveuser/.zshrc

# Copia configs de Codex
mkdir -p /home/liveuser/.config/{hypr,codex,kitty,fastfetch,waybar}
cp -r /etc/skel/.config/. /home/liveuser/.config/ 2>/dev/null || true
chown -R liveuser:liveuser /home/liveuser/

echo "AlphaX live configurado correctamente"