#!/usr/bin/env bash

killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep1; done
# launch bar(s)
# this should deploy 2 bars if both monitors connected
# and just one laptop bar if neither are connected
if [[ $(xrandr -q | grep "DP-3-1 connected") ]] && [[ $(xrandr -q | grep "DP-3-2 connected") ]]; then
    polybar -q --config=$HOME/.config/polybar/config.ini bar_primary &
    polybar -q --config=$HOME/.config/polybar/config.ini bar_secondary &
else
    polybar -q --config=$HOME/.config/polybar/config.ini bar_laptop &
fi
