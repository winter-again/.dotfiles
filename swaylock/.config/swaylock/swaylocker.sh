#!/usr/bin/env bash

# actually using swaylock-effects, a fork of swaylock
swaylock \
    --font "Hack Nerd Font Mono" \
    --clock \
    --datestr "%Y-%m-%d (%b)" \
    --timestr "%l:%M %p" \
    --indicator \
    --inside-color 1a1b26 \
    --inside-clear-color 9d7cd8 \
    --inside-ver-color 1a1b26 \
    --inside-wrong-color 1a1b26 \
    --line-color 292e42 \
    --line-clear-color 292e42 \
    --line-uses-inside \
    --ring-color 292e42 \
    --ring-ver-color 7aa2f7 \
    --ring-wrong-color db4b4b \
    --key-hl-color 9ece6a \
    --text-color c0caf5 \
    --text-clear-color c0caf5 \
    --text-ver-color c0caf5 \
    --text-wrong-color c0caf5 \
    --image "~/Pictures/wallpapers/tokyo-night-wallpaper.jpg" \
    --effect-blur 3x2 \ 
    --fade-in 1
