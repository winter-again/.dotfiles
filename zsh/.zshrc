unsetopt beep hist_beep list_beep

export SHELL="/usr/bin/zsh"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
# -X = don't clear screen on quit
# -F =  quit if one screen
# -R = use limited set of esc sequences
export LESS="-XFR --use-color --ignore-case --incsearch"
# export LESS="-F --ignore-case --incsearch -R --use-color" # need -R for git diff colors
export MANPAGER="nvim +Man!"
# color manpages with bat
# export MANPAGER="sh -c 'awk '\''{ gsub(/\x1B\[[0-9;]*m/, \"\", \$0); gsub(/.\x08/, \"\", \$0); print }'\'' | bat -p -lman'"
# export DIFFPROG="nvim -d"
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/.ripgreprc"
export BROWSER="firefox"
# override some eza colors
# fd reads LS_COLORS, not EZA_COLORS
# see: https://github.com/eza-community/eza/blob/main/man/eza_colors.5.md
# and: https://github.com/eza-community/eza/blob/main/man/eza_colors-explanation.5.md
# di = directories
# ln = symlinks
# or = symlinks with no target
export LS_COLORS="di=1;36:ln=3;92:or=4;91"
# EZA_COLORS supports some codes that LS_COLORS doesn't
# da = date
# uu = your user
export EZA_COLORS=$LS_COLORS:"da=35:uu=1;34:sn=33"

HISTFILE="$XDG_CACHE_HOME/.zsh_history"
SAVEHIST="100000000" # num of lines saved (last $SAVEHIST lines)
HISTSIZE="100000000" # num of lines to keep in one session; read in at start
setopt share_history # inc_append_history + share hist between sessions
setopt hist_ignore_all_dups # keep latest only if dup
setopt hist_save_no_dups # ignore older dups when saving; might be redundant if using hist_ignore_all_dups
setopt hist_ignore_space # ignore commands that start with space

bindkey -v # vi mode
export KEYTIMEOUT=1
bindkey -v "^?" backward-delete-char # make backspace work in vi mode
bindkey "^H" backward-kill-word # ctrl-backspace to del word

zmodload zsh/complist # need for menuselect; load before compinit
bindkey -M menuselect "h" vi-backward-char
bindkey -M menuselect "k" vi-up-line-or-history
bindkey -M menuselect "l" vi-forward-char
bindkey -M menuselect "j" vi-down-line-or-history
bindkey "^F" expand-or-complete # inititate completion menu

autoload -Uz compinit && compinit # autocompletion system
_comp_options+=(globdots) # include hidden files in completion

setopt auto_list # on ambiguous, automatically list
setopt menu_complete # on ambiguous completion insert first match and cycle thru rest
setopt complete_in_word # completion starts from cursor pos

zstyle ":completion:*" menu select # menu-based completion
zstyle ":completion:*" completer _extensions _complete _approximate # completers to use
zstyle ":completion:*" complete-options true # autocomplete for options after dashes
zstyle ":completion:*" file-sort modification # order names by mode time
zstyle ":completion:*" rehash true # automatic rehash; maybe small perf hit
zstyle ":completion:*" matcher-list "" "m:{a-zA-Z}={A-Za-z}" "r:|[._-]=* r:|=*" "l:|=* r:|=*" # try partial words too
zstyle ":completion:*" keep-prefix true # try to keep tilde or param expansions
zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}" # use colors for completing

eval "$(zoxide init zsh)" # must be after compinit called

typeset -U path PATH # prevent path duplicates (keeps only leftmost occurrence)
path+=("$HOME/.local/bin")

# Go
export GOPATH="$HOME/go" # $HOME/go is the default
export GOBIN="$GOPATH/bin" # not set by default
path+=("$(go env GOBIN)")
# export PATH="$PATH:$(go env GOBIN):$(go env GOPATH)/bin" # only necessary if they differ

# Rust
# export PATH="$HOME/.cargo/bin:$PATH" # shouldn't need this if using rustup package from Arch repos

# pnpm global packages
export PNPM_HOME="$HOME/.local/share/pnpm"
path+=("$PNPM_HOME")

export PATH

# Java for pyspark
# export JAVA_HOME="/usr/lib/jvm/java-20-openjdk"

alias ls="eza -a --icons --color=always --group-directories-first"
alias ll="eza -lahM --icons --color=always --group-directories-first --time-style=long-iso"
alias cp="cp -vi"
alias mv="mv -vi"
alias rm="rm -i"
alias tree="eza -la --no-permissions --tree --level=2 --ignore-glob='.git|.venv|node_modules|__pycache__|.pytest_cache'"
alias fd="fd --color=always --hidden --exclude '{.git,.venv,node_modules}'"
alias dots="cd $HOME/.dotfiles"
alias open="xdg-open"
alias grep="grep --color=auto"
alias x="xan"
alias xv="xan view -l 15"
alias xc="xan count"
alias xh="xan headers"
alias j="just"
alias ve="source .venv/bin/activate"
alias de="deactivate"
alias pn="pnpm"
# alias R="R --no-save"
alias wez-logs="cd /run/user/1000/wezterm" # wezterm logs
alias wez-plugs="cd $HOME/.local/share/wezterm/plugins" # wezterm plugins
alias t="task"
alias ta="task active"
alias tl="task +lab"
alias tp="task +personal"
alias tla="task +lab active"
alias tpa="task +personal active"
alias aur="pacman -Qqm"
alias -g -- --help="--help 2>&1 | bat --language=help --style=plain" # color help with bat
alias dust="dust -r"

alias g="git"
alias gap="git add -p"
alias gc="git commit"
alias gp="git push"
alias gs="git status"
alias gb="git branch --all -v"
alias gco="git checkout"
alias gu="git restore --staged"
alias gd="git diff"
alias gds="git diff --staged" # staged changes
alias gdh="git diff HEAD~" # diff latest commit with previous
alias gu="git rm --cached" # stop tracking given file
alias gl="git log --stat --date=format-local:'%Y-%m-%d (%a) %I:%M:%S %p' \
    --format=format:'%C(bold blue)%H%C(reset) - %C(bold magenta)%ad%C(reset) %C(yellow)(%ar)%C(reset) %C(bold cyan)%an%C(reset)%C(auto)%d%C(reset): %s'"
alias glg="git log --all --graph --date=format-local:'%Y-%m-%d (%a) %I:%M:%S %p' \
    --format=format:'%C(bold blue)%h%C(reset) - %C(bold magenta)%ad%C(reset) %C(yellow)(%ar)%C(reset) %C(bold cyan)%an%C(reset)%C(auto)%d%C(reset): %s'"
alias gls="git log --all --oneline --name-status -i --pretty=format:'%C(bold blue)%h%C(reset) - %C(green)%an%C(reset), %C(magenta)%as%C(reset)(%C(yellow)%ar%C(reset)): %s %C(auto)%d%C(reset)' --grep"

# change cwd on exit; use Q instead of q to prevent
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

function f() {
    local dir=$(flow find | fzf --prompt=" Directory: " --no-preview)
    cd "$dir"
}

# follow journalctl for backup services
function bk() {
    journalctl --user -fu "$1" -n 30
}

function mntbk() {
    local UUID="312b6767-e83b-4101-a454-bb24539b7264"
    udisksctl mount -b "/dev/disk/by-uuid/$UUID" && notify-send "Mounted backup drive:" "ext-drive"
    # local drive="/dev/sda1"
    # udisksctl mount -b "$drive" && notify-send "Mounted backup drive:" "$drive"
}

function umntbk() {
    local UUID="312b6767-e83b-4101-a454-bb24539b7264"
    udisksctl unmount -b "/dev/disk/by-uuid/$UUID" && notify-send "Unmounted backup drive:" "ext-drive"
    # local drive="/dev/sda1"
    # udisksctl unmount -b "$drive" && notify-send "Unmounted backup drive:" "$drive"
}

# use fd, follow symlinks, include hidden files, respect .gitignore
export FZF_DEFAULT_COMMAND="fd --type file --follow --strip-cwd-prefix --hidden --exclude '{.git,.venv,node_modules}'"
# + = current line
export FZF_DEFAULT_OPTS="--no-separator
    --layout reverse --height 40% --preview-window '50%'
    --preview 'bat --theme=base16 --color always {}'
    --gutter ' '
    --color=fg:#cacaca,bg:-1,hl:#8a98ac
    --color=fg+:#f0f0f0,bg+:#262626,hl+:underline:#8f8aac
    --color=prompt:#8f8aac,info:#ab9a78,pointer:#cacaca,marker:#778c73
    --color=spinner:#778c73,header:-1,border:#cacaca
    --color=preview-fg:#cacaca,preview-bg:-1"
# fuzzy find command history
export FZF_CTRL_R_OPTS="
    --no-preview
    --bind 'ctrl-h:execute-silent(echo -n {2..} | wl-copy --trim-newline)+abort'
    --header '<ctrl-h> to copy command to clipboard'"
export FZF_CTRL_T_COMMAND="" # disable; don't disable FZF_ALT_C_COMMAND
# these will apply to Ctrl-t after rebind
export FZF_ALT_C_OPTS="
    --walker-skip .git,.venv,node_modules
    --prompt=' Directory: '
    --preview 'eza -la --no-permissions --icons --color=always --tree --level=3 {}'
    --preview-border sharp"
# copy of fzf's cd cmd but with cleaner cd output
function fzf-cd-widget() {
    setopt localoptions pipefail no_aliases 2> /dev/null
    local dir="$(
    FZF_DEFAULT_COMMAND=${FZF_ALT_C_COMMAND:-} \
    FZF_DEFAULT_OPTS=$(__fzf_defaults "--reverse --walker=dir,follow,hidden --scheme=path" "${FZF_ALT_C_OPTS-} +m") \
    FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd) < /dev/tty)"
    if [[ -z "$dir" ]]; then
        zle redisplay
        return 0
    fi
    zle push-line # Clear buffer. Auto-restored on next prompt.
    BUFFER="cd ${(q)dir:a}"
    # BUFFER="builtin cd -- ${(q)dir:a}"
    zle accept-line
    local ret=$?
    unset dir # ensure this doesn't end up appearing in prompt expansion
    zle reset-prompt
    return $ret
}
source <(fzf --zsh) # fzf key bindings and fuzzy completion; should come after vi binds?
bindkey "\C-t" fzf-cd-widget # replace Ctrl-t with functionality of Alt-c (search dir and cd)

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey "^I" autosuggest-accept # tab to accept suggestion (zsh-autosuggestions)
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # source after zsh-autosuggestions

eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/omp-config.json)"
