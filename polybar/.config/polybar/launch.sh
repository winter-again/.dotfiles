#!/usr/bin/env bash

# kill current bars and wait for shut down
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# set CPU thermal zone in case it changed on boot
therm_zone=$(find /sys/class/thermal/thermal_zone*/type | xargs grep x86_pkg_temp | awk -F : '{print $1}' | grep -o -E '[0-9]+')
echo "thermal-zone = $therm_zone" > ~/.config/polybar/thermal_zone

# launch bar(s)
# this should deploy 2 bars if both monitors connected
# and one laptop bar if neither are connected
if [[ $(xrandr -q | grep "DP-3-1 connected") ]] && [[ $(xrandr -q | grep "DP-3-2 connected") ]]; then
    # MONITOR=DP-3-1 polybar --reload --config=$HOME/.config/polybar/config.ini bar_primary &
    # MONITOR=DP-3-2 polybar --reload --config=$HOME/.config/polybar/config.ini bar_secondary &
    polybar --reload --config=$HOME/.config/polybar/config.ini bar_primary &
    polybar --reload --config=$HOME/.config/polybar/config.ini bar_secondary &
else
    polybar --reload --config=$HOME/.config/polybar/config.ini bar_laptop &
fi
