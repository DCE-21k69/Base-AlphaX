#!/bin/bash
# AlphaX - Primer arranque: instala Oh My Zsh y configura zsh

# Instala Oh My Zsh sin interacción
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    # Instala plugins extra
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

    git clone https://github.com/zsh-users/zsh-syntax-highlighting \
        ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

    echo "Oh My Zsh instalado ✓"
fi

# Cambia shell a zsh
chsh -s $(which zsh) $USER
echo "ZSH configurado como shell por defecto ✓"
