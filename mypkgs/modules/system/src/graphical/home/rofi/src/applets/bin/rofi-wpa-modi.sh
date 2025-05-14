get_curent() {
  iwgetid -r
}

format_wifi() {
  SECU=$(echo "$1" | cut -d "&" -f 4);
  NAME=$(echo "$1" | cut -d "&" -f 5 | sed 's/___/ /g');
  [[ "${NAME}x" == "x" || "${SECU}x" == "x" || "${NAME}a" == "\x"* ]] \
    && return
  
  echo "${SECU} ${NAME}\0icon\x1f~/.config/rofi/applets/icon/wifi.png" | sed -r "s/\[[^:]*WPA[^:]*\]//g" | sed -r "s/\[[^:]*\]//g";
}

wifi_get_name() {
  echo "${1}" | sed 's/ //g' | sed 's/ //g'
}

get_wifi() {
  for i in $(
    wpa_cli scan_results \
      | grep -v 'bssid / frequency' \
      | grep -v 'Selected interface' \
      | sed 's/\t/\&/g' | sed 's/ /___/g'
  ); do
  echo "$(format_wifi $i)" &
  done
  wait
}

get_wifi_id() {
  WIFI_NAME="$(wifi_get_name "${1}")"

  wpa_cli list_networks \
    | sed -n "/\t${WIFI_NAME}\t/p" \
    | cut -d $'\t' -f 1
}

remove_network() {
  echo "
    disconnect
    disable_network ${WIFI_ID}
    set_network ${WIFI_ID} priority 0
    remove_network ${WIFI_ID}
    reconnect
  " | wpa_cli > /dev/null

  rm -rf /etc/wpa_supplicant/wpa_supplicant_${SSID}.conf
}

log_to_saved_wifi() {
  WIFI_NAME="$(wifi_get_name "${1}")"
  CURENT="$(get_wifi_id "$(get_curent)")"
  WIFI_ID="$(get_wifi "${WIFI_NAME}")"

  echo "
    disconnect
    set_network ${CURENT} priority 0
    set_network ${WIFI_ID} priority 10
    reconnect
  " | wpa_cli > /dev/null
}

log_to_passwordless_wifi() {
  SSID="$(wifi_get_name "${1}")"
  CURENT="$(get_wifi_id "$(get_curent)")"
  WIFI_ID=$(wpa_cli add_network | grep -v 'Selected interface')

  echo "
    disconnect
    set_network ${CURENT} priority 0
    set_network ${WIFI_ID} ssid \"${SSID}\"
    set_network ${WIFI_ID} key_mgmt NONE
    set_network ${WIFI_ID} priority 10
    enable_network ${WIFI_ID}
    reconnect
  " | wpa_cli > ./logs.txt
}

log_to_secure_wifi() {
  PASSWORD="${2}"
  SSID="$(wifi_get_name "${1}")"
  CURENT="$(get_wifi_id "$(get_curent)")"
  WIFI_ID=$(wpa_cli add_network | grep -v 'Selected interface')

  echo "
    disconnect
    set_network ${CURENT} priority 0
    set_network ${WIFI_ID} ssid \"${SSID}\"
    set_network ${WIFI_ID} psk \"${PASSWORD}\"
    set_network ${WIFI_ID} key_mgmt WPA-PSK
    set_network ${WIFI_ID} priority 10
    enable_network ${WIFI_ID}
    reconnect
  " | wpa_cli > /dev/null
}

save_network() {
  if [[ ! -f /etc/wpa_supplicant/wpa_supplicant.conf ]]; then
    sudo mkdir -p /etc/wpa_supplicant/

    sudo bash -c "echo -e 'ctrl_interface=/run/wpa_supplicant' \
      > /etc/wpa_supplicant/wpa_supplicant.conf"
    sudo bash -c "echo -e 'ctrl_interface_group=wheel' \
      >> /etc/wpa_supplicant/wpa_supplicant.conf"
    sudo bash -c "echo -e 'update_config=1' \
      >> /etc/wpa_supplicant/wpa_supplicant.conf"
  fi

  wpa_cli save_config > /dev/null
}
load_network() {
  if [[ ! -f /etc/wpa_supplicant/wpa_supplicant.conf ]]; then
    sudo mkdir -p /etc/wpa_supplicant/

    sudo bash -c "echo -e 'ctrl_interface=/run/wpa_supplicant' \
      > /etc/wpa_supplicant/wpa_supplicant.conf"
    sudo bash -c "echo -e 'ctrl_interface_group=wheel' \
      >> /etc/wpa_supplicant/wpa_supplicant.conf"
    sudo bash -c "echo -e 'update_config=1' \
      >> /etc/wpa_supplicant/wpa_supplicant.conf"
  fi

  sudo systemctl stop wpa_supplicant.service
  sudo wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf
}

check_wifi_log() {

  SSID="$(wifi_get_name "${1}")"

  COUNT=0
  while [[ "$(iwgetid -r)x" != "${SSID}x" && ${COUNT} -le 15 ]]; do
    sleep 1
    COUNT=$((COUNT + 1))
  done

  if [ "$(get_curent)x" == "${SSID}x" ]; then
    save_network
    echo "" > ~/.cache/rofi-wpa/WIFI_NAME
  else
    echo -en "Failed (Supprimer)\0icon\x1f~/.config/rofi/applets/icon/error.png"
    echo -en "Failed (Conserver)\0icon\x1f~/.config/rofi/applets/icon/warn.png"
    echo -en "Ou rentrez un MDP ici\0icon\x1f~/.config/rofi/applets/icon/ok.png"
  fi
}

if [[ -z "${1}" ]]; then
  wpa_cli scan *> /dev/null

  CURENT="$(iwgetid -r)"
  WIFI="${CURENT}"

  while [[
    "${WIFI}x" == "x"
  ]] || [[
    "$(wifi_get_name "${WIFI}")x" == "${CURENT}x"
    && "${CURENT}x" != "x"
  ]]; do
    WIFI="$(get_wifi | sort -u | uniq)"
  done

  echo -en "󰖂 WireGuard\0icon\x1f~/.config/rofi/applets/icon/wireguard.png"
  echo -en "${WIFI}"

elif [[ "${1}x" == "󰖂 WireGuardx" ]]; then
  [[ ! -d "/etc/wireguard" ]] && \
    echo -en "Wireguard non installer\0icon\x1f~/.config/rofi/applets/icon/error.png"

elif [[ "${1}x" == "Wireguard non installerx" ]]; then
  exit 1

elif [[ "${1}x" == "Failed (Supprimer)x" ]]; then
  SSID="$(cat ~/.cache/rofi-wpa/WIFI_NAME)"
  wpa_cli remove_network "$(get_wifi_id "${SSID}")"} > /dev/null 
  echo "" > ~/.cache/rofi-wpa/WIFI_NAME
  exit 1

elif [[ "${1}x" == "Failed (Conserver)x" ]]; then
  exit 1

elif [ "$(get_wifi_id "${1}")x" != "x" ]; then
  log_to_saved_wifi "${1}"
  echo "$(wifi_get_name "${1}")" > ~/.cache/rofi-wpa/WIFI_NAME
  check_wifi_log "${1}"

elif [[ "${1}x" == " "* ]]; then
  log_to_passwordless_wifi "${1}"
  echo "$(wifi_get_name "${1}")" > ~/.cache/rofi-wpa/WIFI_NAME
  check_wifi_log "${1}"

elif [[ "${1}x" == " "* ]]; then
  mkdir -p ~/.cache/rofi-wpa/
  echo "$(wifi_get_name "${1}")" > ~/.cache/rofi-wpa/WIFI_NAME
  
  echo -en "Entrez votre MDP WIFI\0icon\x1f~/.config/rofi/applets/icon/ok.png"

elif [[ "$(cat ~/.cache/rofi-wpa/WIFI_NAME)x" != "x" ]]; then
  SSID="$(cat ~/.cache/rofi-wpa/WIFI_NAME)"
  PASSWORD="${1}"

  log_to_secure_wifi "${SSID}" "${PASSWORD}"
  check_wifi_log "${SSID}"
elif [ "${1}x" != "-lx" ]; then
  load_network
fi
