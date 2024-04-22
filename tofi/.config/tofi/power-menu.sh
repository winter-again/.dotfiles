#!/usr/bin/env bash

case $(printf "%s\n" "Power off" "Reboot" "Suspend" "Lock" "Log out" | tofi --width 260 --height 260) in
    "Power off")
        exec systemctl poweroff;;
    "Reboot")
        exec systemctl reboot;;
    "Suspend")
        exec systemctl suspend;;
    "Lock")
        gtklock -t "%I:%m %p";;
    "Log out")
        swaymsg exit;;
esac
