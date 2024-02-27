#!/usr/bin/env bash

default=("default") # hard-coded value
    bgs=$(cat ~/.dotfiles/wezterm/.config/wezterm/lua/profile_data.lua | grep -oE "bg_[0-9]+(_[0-9]+)?")
bgs=("${default[@]}" "${bgs[@]}")

# takes advantage of the wezterm-config.nvim plugin's structure
# and the user-var already defined in my wezterm config
if [[ -z "${TMUX}" ]]; then
    sel=$(printf "%s\n" "${bgs[@]}" | fzf --prompt="󱣴 Background switcher: " --no-preview) # note fzf-tmux pop up window here
    printf "\033]1337;SetUserVar=%s=%s\007" "background" `echo -n "$sel" | base64`
else
    sel=$(printf "%s\n" "${bgs[@]}" | fzf-tmux -p 25%,25% --prompt="󱣴 Background switcher: " --no-preview) # note fzf-tmux pop up window here
    # sometimes doesn't work first try...seems like tmux issue
    printf "\033Ptmux;\033\033]1337;SetUserVar=%s=%s\007\033\\" "background" `echo -n "$sel" | base64`
fi
