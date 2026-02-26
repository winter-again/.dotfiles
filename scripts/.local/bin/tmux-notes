#!/usr/bin/env bash

if tmux has-session -t "00"; then
    tmux switch-client -t "00"
    tmux new-window -S -c "$HOME/Documents/notebook" -n "notes"
else
    tmux new-session -c "$HOME/Documents/notebook" -s "00" -n "notes"
    tmux switch-client -t "00:notes"
fi
