#!/usr/bin/env bash

# modified from Primeagen

if tmux list-sessions &>/dev/null; then
	TMUX_RUNNING=1
else
	TMUX_RUNNING=0
fi

# checks if only one arg passed
# aka a dir as the only arg
if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(fd . \
        ~/Documents/Bansal-lab \
        ~/Documents/code \
        ~/Documents/code/nvim-dev \
        --min-depth 1 --max-depth 1 --type d | \
        fzf-tmux -p --prompt=" Session: " --no-preview)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _) # need to sub . for _ b/c of tmux

# start tmux itself it isn't already running
# w/ selected session
if [[ -z $TMUX ]] && [[ $TMUX_RUNNING -eq 0 ]]; then
    tmux new-session -s $selected_name -c $selected
    exit 0
fi

# create session if it doesn't exist
if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected
fi

# switch session if it exists
tmux switch-client -t $selected_name
