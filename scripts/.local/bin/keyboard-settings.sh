#!/usr/bin/env bash

# remap caps lock to ctrl
setxkbmap -option "ctrl:swapcaps"
# faster keys:
# delay in ms before autorepeat starts
# repeat rate
xset r rate 200 40
