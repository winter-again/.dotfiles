unsetopt beep hist_beep list_beep

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

zstyle ':completion:*' menu select # menu-based completion
zstyle ':completion:*' completer _extensions _complete _approximate # completers to use
zstyle ':completion:*' complete-options true # autocomplete for options after dashes
zstyle ':completion:*' file-sort modification # order names by mode time
zstyle ':completion:*' rehash true # automatic rehash; maybe small perf hit
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*' # try partial words too
zstyle ':completion:*' keep-prefix true # try to keep tilde or param expansions
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # use colors for completing

eval "$(zoxide init zsh)" # must be after compinit called

export SHELL="/usr/bin/zsh"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export EDITOR="/usr/local/bin/nvim"
export VISUAL="/usr/local/bin/nvim"
export PAGER="/usr/bin/less"
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
# export MANPAGER="less -R --use-color -Dd+r -Du+b" # simple colors
export BROWSER="firefox"

# override defaults
# see: https://github.com/eza-community/eza/blob/d477699f89f2346be712f287287a7205f37933e9/man/eza_colors.5.md
export LS_COLORS="di=1;36"
# seems only EZA_COLORS has "da" option
export EZA_COLORS="da=1;36"

# make fd use same colors as eza (set $LS_COLORS)
# eval "$(dircolors -b)"

typeset -U path PATH # prevent path duplicates (keeps only leftmost occurrence)
path+=("$HOME/.local/bin")

# Go
export GOPATH="$HOME/go" # $HOME/go is already the default
export GOBIN="$GOPATH/bin" # binaries installed here, not set by default
path+=("$(go env GOBIN)")
# export PATH="$PATH:$(go env GOBIN):$(go env GOPATH)/bin" # only necessary if they differ

# Rust
# export PATH="$HOME/.cargo/bin:$PATH" # shouldn't need this if using rustup package from Arch repos

# pnpm global packages
export PNPM_HOME="$HOME/.local/share/pnpm"
path+=("$PNPM_HOME")

export PATH

# fnm
# `--use-on-cd` flag will automatically run `fnm use` when a dir contains a `.node-version` or `.nvmrc` file
# `--version-file-strategy=recursive` might also make sense; default is local
# using both = auto use/install the right Node version when going into proj subdirs and moving between proj
# eval "$(fnm env --use-on-cd --shell zsh)"

# Java for pyspark
# export JAVA_HOME="/usr/lib/jvm/java-20-openjdk"

# aliases
alias ls="eza -a --icons --color=always --group-directories-first"
alias ll="eza -lah --icons --color=always --group-directories-first"
alias tree="ls -lh --tree --level=2"
alias open="xdg-open"
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias grep="grep --color=auto"
alias tv="tidy-viewer"
alias R="R --no-save" # never prompt to save workspace image
alias ve="source .venv/bin/activate"
alias de="deactivate"
alias fd="fd --hidden"
alias pn="pnpm"
alias tr="trash-put"
alias -g -- --help="--help 2>&1 | bat --language=help --style=plain" # colorize help with bat
alias gs="git status"
alias ga="git add"
alias gb="git branch --all -v"
alias gc="git commit"
alias gc="git checkout"
alias gu="git restore --staged" # recommended undo for staged file
alias gd="git diff"
alias gds="git diff --staged" # staged changes
alias gdh="git diff HEAD~" # diff latest commit with previous
alias gu="git rm --cached" # stop tracking given file
alias gl="git log --stat"
alias glg="git log --all --graph --oneline"
alias glp="git log --pretty=format:'%C(bold blue)%h%C(reset) - %C(green)%an%C(reset), %C(magenta)%as%C(reset)(%C(yellow)%ar%C(reset)): %s %C(auto)%d%C(reset)'"
alias glf="git log --oneline --name-status -i --pretty=format:'%C(bold blue)%h%C(reset) - %C(green)%an%C(reset), %C(magenta)%as%C(reset)(%C(yellow)%ar%C(reset)): %s %C(auto)%d%C(reset)' --grep"
alias gpull="git pull"
alias gpush="git push"
alias ggrep="git ls-files | grep -i"
alias t="task"
alias ta="task active"
alias tl="task +lab"
alias tp="task +personal"

# functions
# let yazi change dir
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

function ff() {
    local dir
    if [[ -z "${TMUX}" ]]; then
        dir=$(fd . \
            ~/Documents/Bansal-lab \
            ~/Documents/code \
            ~/Documents/code/nvim-dev \
            --min-depth 1 --max-depth 1 --type d | fzf --prompt=" Directory: " --no-preview --color="bg:-1")
    else
        dir=$(fd . \
            ~/Documents/Bansal-lab \
            ~/Documents/code \
            ~/Documents/code/nvim-dev \
            --min-depth 1 --max-depth 1 --type d | fzf-tmux -p --prompt=" Directory: " --no-preview --color="bg:-1")
    fi
    cd "$dir"
}

function dots() {
    cd ~/.dotfiles
}

# show journalctl for backup services
function bk() {
    journalctl --user -fu "$1" -n 30
}

function mntbk() {
    out=$(udisksctl mount -b /dev/sda1)
    notify-send "Mounted backup drive" "$out"
}

function umntbk() {
    out=$(udisksctl unmount -b /dev/sda1)
    notify-send "Unmounted backup drive" "$out"
}

# wezterm logs appear here
# function wez-logs() {
#     cd /run/user/1000/wezterm
#     ls
# }
# function wez-plugs() {
#     cd ~/.local/share/wezterm/plugins
#     ls
# }

# fzf
source /usr/share/fzf/key-bindings.zsh # fzf keybinds
source /usr/share/fzf/completion.zsh # fzf fuzzy completion
export FZF_DEFAULT_OPTS="--height 40%
    --layout reverse
    --preview 'bat --theme=base16 --color always {}'
    --no-separator
    --preview-window '50%'
    --color=fg:#cacaca,bg:-1,hl:underline:#8f8aac \
    --color=fg+:#f0f0f0,bg+:#262626,hl+:underline:#8a98ac \
    --color=info:#c6a679,prompt:#8f8aac,pointer:#f0f0f0
    --color=marker:#8aac8b,spinner:#8aac8b
    --color=gutter:-1,border:#8a98ac,header:-1
    --color=preview-fg:#f0f0f0,preview-bg:-1"

# use fd, follow symlinks, include hidden files, respect .gitignore (https://github.com/junegunn/fzf#respecting-gitignore)
export FZF_DEFAULT_COMMAND="fd --type f --strip-cwd-prefix --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND" # search cwd and output to stdout
# preview file content with fzf + bat; ctrl-/ changes the preview window style
export FZF_CTRL_T_OPTS="
    --preview 'bat -n --color=always {}'
    --bind 'ctrl-/:change-preview-window(down|hidden|)'"
# fuzzy find command history; ctrl-/ toggles preview window, ctrl-Y copies command to clipboard via xclip
export FZF_CTRL_R_OPTS="
    --preview 'echo {}' --preview-window up:3:hidden:wrap
    --bind 'ctrl-/:toggle-preview'
    --bind 'ctrl-y:execute-silent(echo -n {2..} | xclip -se c)+abort'
    --color header:italic
    --header 'CTRL-Y to copy command to clipboard'"

# fix uv run autocomplete for py files: https://github.com/astral-sh/uv/issues/8432
if type "uv" > /dev/null; then
    eval "$(uv generate-shell-completion zsh)"
    eval "$(uvx --generate-shell-completion zsh)"

    _uv_run_mod() {
        if [[ "$words[2]" == "run" && "$words[CURRENT]" != -* ]]; then
            _arguments '*:filename:_files -g "*.py"'
        else
            _uv "$@"
        fi
    }

    compdef _uv_run_mod uv
fi

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey "^I" autosuggest-accept # tab to accept suggestion (zsh-autosuggestions)

eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/omp_config.toml)"
