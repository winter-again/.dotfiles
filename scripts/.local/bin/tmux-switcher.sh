#!/usr/bin/env bash

tmux_switcher() {
    if tmux list-sessions &>/dev/null; then
        TMUX_RUNNING=1
    else
        TMUX_RUNNING=0
    fi

    # need v0.45.0 for this: https://github.com/junegunn/fzf/blob/master/ADVANCED.md#toggling-with-a-single-key-binding
    # would be nice to map just tab to toggle the view of sources
    # also read: https://github.com/junegunn/fzf/releases/tag/0.45.0
    if [[ "$TMUX_RUNNING" -eq 1 ]]; then
        selection=$(tmux list-sessions -F "#{session_name}" | \
            fzf-tmux \
            --layout reverse \
            --prompt=" Sessions: " \
            --no-multi \
            --header "<tab>: common dirs / <shift-tab>: sessions" \
            -p 80%,60% \
            --bind "tab:change-preview-window(hidden)+change-prompt( Common dirs: )+reload(fd . ~/Documents/Bansal-lab ~/Documents/code ~/Documents/code/nvim-dev --min-depth 1 --max-depth 1 --type d)" \
            --bind "shift-tab:preview(~/.local/bin/tmux-switcher-preview.sh {})+change-prompt( Sessions)+reload(tmux list-sessions -F '#{session_name}')" \
            --bind "ctrl-k:execute(tmux kill-session -t {})+reload(tmux list-sessions -F '#{session_name}')" \
            --preview "~/.local/bin/tmux-switcher-preview.sh {}" \
            --preview-window "right:65%" \
            --preview-window "border-left" \
            --preview-label "Currently active pane" \
            --border rounded \
            --no-separator \
            --color=fg:#c0caf5,bg:-1,hl:#9d7cd8 \
            --color=fg+:#c0caf5,bg+:#283457,hl+:#7dcfff \
            --color=info:#ff9e64,prompt:#9d7cd8,pointer:#c0caf5 \
            --color=marker:#9ece6a,spinner:#9ece6a \
            --color=gutter:-1,border:#7aa2f7,header:-1 \
            --color=preview-fg:#c0caf5,preview-bg:-1
        )
    else
        echo "tmux not running..."
        exit 0
    fi

    if [[ -z $selection ]]; then
        exit 0
    fi

    # rudimentary test of whether selection is a file path vs. a session name
    # is it actually fine to do a the [[ -d ... ]] check?
    if [[ $selection == *"/"* ]]; then
        session_name=$(basename "$selection" | tr . _) # clean name
        if ! tmux has-session -t $session_name 2> /dev/null; then
            tmux new-session -d -s $session_name -c $selection
        fi
    else
        session_name=$selection
    fi
    tmux switch-client -t $session_name
}

tmux_switcher
