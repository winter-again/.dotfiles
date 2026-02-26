#!/usr/bin/env bash

# return contents of pane based on the given session's current window's current/active pane
function get_preview_contents() {
    session_name="${1}"
    # omitting the pane index defaults to the currently active pane in the specified window
    active_pane_id=$(tmux display-message -t "${session_name}:${active_window_idx}" -p "#{pane_id}") 
    tmux capture-pane -ep -t "${active_pane_id}"
}

get_preview_contents "$1"
