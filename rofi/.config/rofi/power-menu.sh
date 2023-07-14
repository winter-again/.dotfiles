#!/usr/bin/env bash

theme="$HOME/.config/rofi/config.rasi"

chosen=$(printf " Power off\n Restart\n󰒲 Suspend\n󰍃 Logout\n󰌾 Lock" | rofi -dmenu -p "Power:" -dpi 1 -theme ${theme})

case "$chosen" in
    " Power off") systemctl poweroff ;;
    " Restart") systemctl reboot ;;
    "󰒲 Suspend") systemctl suspend ;;
    "󰍃 Logout") i3-msg exit ;;
    "󰌾 Lock") betterlockscreen --lock dim 5 ;;
    *) exit 1 ;;
esac
