#!/usr/bin/env bash

case $(printf "%s\n" "Power off" "Reboot" "Suspend" "Hibernate" "Lock" "Log out" | tofi --width 260 --height 260) in
    "Power off")
        exec systemctl poweroff;;
    "Reboot")
        exec systemctl reboot;;
    "Suspend")
        exec systemctl suspend;;
    "Hibernate")
        exec systemctl hibernate;;
    "Lock")
        gtklock -t "%I:%m %p";;
    "Exit Sway")
        swaymsg exit;;
esac
