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
    # --header $'\e[1;34mHi mom\e[m' \
    if [[ "$TMUX_RUNNING" -eq 1 ]]; then
        # selection=$(tmux list-sessions -F "#{session_name}" | \
        #     fzf-tmux \
        #     --layout reverse \
        #     --no-multi \
        #     -p 80%,60% \
        #     --prompt=" Sessions: " \
        #     --header $'\e[1;34m<tab>\e[m: common dirs / \e[1;34m<shift-tab>\e[m: sessions /\n\e[1;34m<ctrl-k>\e[m: kill session' \
        #     --bind "tab:change-preview-window(hidden)+change-prompt( Common dirs: )+reload(fd . ~/Documents/Bansal-lab ~/Documents/code ~/Documents/code/nvim-dev --min-depth 1 --max-depth 1 --type d)" \
        #     --bind "shift-tab:preview(~/.local/bin/tmux-switcher-preview.sh {})+change-prompt( Sessions)+reload(tmux list-sessions -F '#{session_name}')" \
        #     --bind "ctrl-k:execute(tmux kill-session -t {})+reload(tmux list-sessions -F '#{session_name}')" \
        #     --preview "$HOME/.local/bin/tmux-switcher-preview.sh {}" \
        #     --preview-window "right:65%" \
        #     --preview-window "border-left" \
        #     --preview-label "Currently active pane" \
        #     --border rounded \
        #     --no-separator \
        #     --color=fg:#c0caf5,bg:-1,hl:underline:#9d7cd8 \
        #     --color=fg+:#c0caf5,bg+:#283457,hl+:underline:#7dcfff \
        #     --color=info:#ff9e64,prompt:#9d7cd8,pointer:#c0caf5 \
        #     --color=marker:#9ece6a,spinner:#9ece6a \
        #     --color=gutter:-1,border:#7aa2f7,header:-1 \
        #     --color=preview-fg:#c0caf5,preview-bg:-1
        # )
        selection=$(tmux list-sessions -F "#{session_name}" | \
            fzf-tmux \
            --layout reverse \
            --no-multi \
            -p 80%,60% \
            --prompt=" Sessions: " \
            --header $'\e[1;34m<tab>\e[m: common dirs / \e[1;34m<shift-tab>\e[m: sessions /\n\e[1;34m<ctrl-k>\e[m: kill session' \
            --bind "tab:change-preview-window(hidden)+change-prompt( Common dirs: )+reload(fd . ~/Documents/Bansal-lab ~/Documents/code ~/Documents/code/nvim-dev --min-depth 1 --max-depth 1 --type d)" \
            --bind "shift-tab:preview(~/.local/bin/tmux-switcher-preview.sh {})+change-prompt( Sessions)+reload(tmux list-sessions -F '#{session_name}')" \
            --bind "ctrl-k:execute(tmux kill-session -t {})+reload(tmux list-sessions -F '#{session_name}')" \
            --preview "$HOME/.local/bin/tmux-switcher-preview.sh {}" \
            --preview-window "right:65%" \
            --preview-window "border-left" \
            --preview-label "Currently active pane" \
            --border rounded \
            --no-separator \
            --color=fg:#f0f0f0,bg:-1,hl:underline:#8f8aac \
            --color=fg+:#f0f0f0,bg+:#262626,hl+:underline:#8a98ac \
            --color=info:#c6a679,prompt:#8f8aac,pointer:#f0f0f0 \
            --color=marker:#8aac8b,spinner:#8aac8b \
            --color=gutter:-1,border:#8a98ac,header:-1 \
            --color=preview-fg:#f0f0f0,preview-bg:-1
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
        if ! tmux has-session -t "$session_name" 2> /dev/null; then
            tmux new-session -d -s "$session_name" -c "$selection"
        fi
    else
        session_name=$selection
    fi
    tmux switch-client -t "$session_name"
}

tmux_switcher
