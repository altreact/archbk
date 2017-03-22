#!/usr/bin/env bash
hidden_ssid () {
  read -p "enter hidden SSID: " a
  ssid=$a
  
  read -p "enter password: " a
  passwd=$a
  
  passwd="$(wpa_passphrase home $ssid $passwd | grep -e "[ ]*psk" | tail -n1 | sed s/[^0-9]*//)"
  
  echo $ssid
  echo $passwd
  
  cat /etc/netctl/examples/wireless-wpa | sed 's/wlan/mlan/' | sed 's/#P/P/' | sed 's/#H/H/' | sed "s/MyNetwork/$ssid/" | sed "s/WirelessKey/$passwd/" > /etc/netctl/network
  
  netctl enable network && netctl start network
}