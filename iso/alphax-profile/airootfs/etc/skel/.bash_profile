# AlphaX - primer arranque
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    alphax-firstrun.sh
fi

# Si zsh está disponible, úsalo
if [ -x /usr/bin/zsh ]; then
    exec zsh
fi
