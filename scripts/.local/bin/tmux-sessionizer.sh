#!/usr/bin/env bash

# from Primeagen
if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(fd . \
        ~/Documents/Bansal-lab \
        ~/Documents/code \
        ~/Documents/code/nvim-dev \
        --min-depth 1 --max-depth 1 --type d | fzf-tmux -p --prompt=" Session: " --no-preview)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _) # need to sub . for _ b/c of tmux
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    exit 0
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected
fi

tmux switch-client -t $selected_name
