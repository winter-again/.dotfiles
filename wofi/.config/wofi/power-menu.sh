#!/usr/bin/env bash

# source: https://github.com/luispabon/sway-dotfiles/blob/1a255c86a65e9f3059bac0eea137875b22a5e787/scripts/wofi-power.sh#L4
entries="󰌾 Lock\n󰍃 Logout\n󰒲 Suspend\n Reboot\n⏻ Shutdown"

selected=$(echo -e $entries | wofi -p "Power" --width 25% --height 275 --dmenu --cache-file /dev/null | awk '{print tolower($2)}')

case $selected in
    lock)
        swaylock --config ~/.config/swaylock/config;;
    logout)
        swaymsg exit;;
    suspend)
        exec systemctl suspend;;
    reboot)
        exec systemctl reboot;;
    shutdown)
        exec systemctl poweroff;;
esac
