# ~/.bashrc - AlphaX Linux

# Flatpak
export XDG_DATA_DIRS=$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:~/.local/share/flatpak/exports/share

# Aliases útiles
alias ls='ls --color=auto'
alias ll='ls -lah'
alias update='sudo pacman -Syu && flatpak update -y'
alias aur='yay -S'
