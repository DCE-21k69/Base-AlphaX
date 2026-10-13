#!/usr/bin/env bash
# ═══════════════════════════════════════════════════
# Codex WM — WiFi Menu (soporta SSIDs con espacios y caracteres especiales)
# ═══════════════════════════════════════════════════
set -euo pipefail

notify-send "WiFi" "Escaneando redes..." --icon=network-wireless

# Solicitar re-escaneo sin bloquear si ya se hizo uno reciente
nmcli device wifi rescan 2>/dev/null || true

# Obtener redes en modo delimitado (-t) con separador ':'
# Usamos awk para separar de derecha a izquierda (SECURITY y SIGNAL son los últimos 2 campos, el resto es SSID)
mapfile -t RAW_LIST < <(
    nmcli -t -f SSID,SIGNAL,SECURITY device wifi list | awk -F: '
    NF >= 3 {
        sec = $NF
        sig = $(NF-1)
        ssid = ""
        for (i = 1; i <= NF-2; i++) {
            ssid = (i == 1 ? $i : ssid ":" $i)
        }
        gsub(/\\:/, ":", ssid)
        if (ssid != "" && !seen[ssid]++) {
            if (sec == "") sec = "Abierta"
            printf "%s\t󰤨 %3s%%  [%s]  %s\n", ssid, sig, sec, ssid
        }
    }' | sort -t$'\t' -k2 -rn | head -n 25
)

if [ "${#RAW_LIST[@]}" -eq 0 ]; then
    notify-send "WiFi" "No se encontraron redes Wi-Fi cercanas" --icon=network-wireless-disconnected
    exit 0
fi

# Mostrar solo la columna visual en rofi
DISPLAY_MENU=$(printf '%s\n' "${RAW_LIST[@]}" | cut -f2)

CHOSEN_LINE=$(printf '%s\n' "$DISPLAY_MENU" | rofi -dmenu -i \
    -p "󰤨  WiFi" \
    -theme-str 'window {width: 460px;}' \
    -no-custom || true)

[ -z "$CHOSEN_LINE" ] && exit 0

# Recuperar el SSID exacto correspondiente a la línea elegida
SSID=""
for entry in "${RAW_LIST[@]}"; do
    label="${entry#*$'\t'}"
    if [ "$label" = "$CHOSEN_LINE" ]; then
        SSID="${entry%%$'\t'*}"
        break
    fi
done

[ -z "$SSID" ] && exit 0

# Si ya existe un perfil guardado para este SSID, activarlo directamente
if nmcli -t -f NAME connection show | grep -Fxq "$SSID"; then
    if nmcli connection up id "$SSID"; then
        notify-send "WiFi" "Conectado a $SSID 󰤨" --icon=network-wireless
        exit 0
    fi
fi

# Si la red es abierta, conectar sin contraseña
if [[ "$CHOSEN_LINE" == *"[Abierta]"* ]] || [[ "$CHOSEN_LINE" == *"[--]"* ]]; then
    if nmcli device wifi connect "$SSID"; then
        notify-send "WiFi" "Conectado a $SSID 󰤨" --icon=network-wireless
    else
        notify-send "WiFi" "Error al conectar a $SSID" --icon=network-error
    fi
    exit 0
fi

# Pedir contraseña para redes protegidas
PASS=$(rofi -dmenu \
    -p "󰌆 Contraseña ($SSID)" \
    -theme-str 'window {width: 400px;}' \
    -password || true)

[ -z "$PASS" ] && exit 0

if nmcli device wifi connect "$SSID" password "$PASS"; then
    notify-send "WiFi" "Conectado a $SSID 󰤨" --icon=network-wireless
else
    notify-send "WiFi" "Error al conectar a $SSID" --icon=network-error
fi
