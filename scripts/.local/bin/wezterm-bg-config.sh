#!/usr/bin/env bash

default=("default") # hard-coded value
bgs=$(cat ~/.dotfiles/wezterm/.config/wezterm/profile_data.lua | grep -oE "bg_[0-9]+")
bgs=("${default[@]}" "${bgs[@]}")
sel=$(printf "%s\n" "${bgs[@]}" | fzf-tmux -p 25%,25% --prompt="Background switcher: " --no-preview) # note fzf-tmux pop up window here

# takes advantage of the wezterm-config.nvim plugin's structure
# and the user-var already defined in my wezterm config
printf "\033Ptmux;\033\033]1337;SetUserVar=%s=%s\007\033\\" "profile_background" `echo -n "$sel" | base64`
