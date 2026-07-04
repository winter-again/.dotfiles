#!/usr/bin/env bash

case $(printf "%s\n" "Power off" "Reboot" "Suspend" "Hibernate" "Lock" "Exit Sway" | tofi --width 200 --height 200) in
"Power off")
    exec systemctl poweroff
    ;;
"Reboot")
    exec systemctl reboot
    ;;
"Suspend")
    exec systemctl suspend
    ;;
"Hibernate")
    exec systemctl hibernate
    ;;
"Lock")
    gtklock
    ;;
"Exit Sway")
    swaymsg exit
    ;;
esac
