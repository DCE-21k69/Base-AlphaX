#!/bin/bash
# Codex WiFi Menu — redes cercanas con rofi

notify-send "WiFi" "Escaneando redes..." --icon=network-wireless

# Lista de redes disponibles
NETWORKS=$(nmcli -f SSID,SIGNAL,SECURITY device wifi list | tail -n +2 | \
    awk '{printf "%-35s 󰤨 %s%% %s\n", $1, $2, $3}' | sort -k3 -rn | head -20)

# Selección con rofi
CHOSEN=$(echo "$NETWORKS" | rofi -dmenu \
    -p "󰤨  WiFi" \
    -theme-str 'window {width: 400px;}' \
    -no-custom)

[ -z "$CHOSEN" ] && exit

# Extrae el SSID
SSID=$(echo "$CHOSEN" | awk '{print $1}')

# Intenta conectar
if nmcli connection show "$SSID" &>/dev/null; then
    nmcli connection up "$SSID" && \
        notify-send "WiFi" "Conectado a $SSID 󰤨" --icon=network-wireless
else
    # Pide contraseña si es necesario
    PASS=$(rofi -dmenu -p "󰌆 Contraseña para $SSID" \
        -theme-str 'window {width: 350px;}' \
        -password)
    [ -z "$PASS" ] && exit
    nmcli device wifi connect "$SSID" password "$PASS" && \
        notify-send "WiFi" "Conectado a $SSID 󰤨" --icon=network-wireless || \
        notify-send "WiFi" "Error al conectar a $SSID" --icon=network-wireless
fi
