#!/usr/bin/env bash

# simple session switcher
if tmux list-sessions &>/dev/null; then
	TMUX_RUNNING=1
else
	TMUX_RUNNING=0
fi

# only runs if tmux is running
if [[ "$TMUX_RUNNING" -eq 1 ]]; then
    selected=$(tmux list-sessions | \
        awk -F ':' '{print $1}' | \
        fzf-tmux -p 25% --prompt=" Session: " --no-preview)
else
    echo "tmux not running..."
    exit 0
fi

if [[ -z $selected ]]; then
    exit 0
fi

tmux switch-client -t $selected
