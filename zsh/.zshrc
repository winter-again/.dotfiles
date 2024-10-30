#!/bin/sh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh # load prompt config
# source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme # load p10k
#######################

# zmodload zsh/zprof # profiler
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE # num of commands stored
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export SHELL=/bin/zsh
# for wezterm undercurl supp, but it seems to cause partial line issues?
# without it underlines look ok??
# export TERM=wezterm
export EDITOR="nvim"
export VISUAL="nvim"
# export MANPAGER="sh -c 'col -bx | bat -l man -p'" # bat for colorizing pager for man
export MANPAGER="less -R --use-color -Dd+r -Du+b" # simple colors
export MANROFFOPT="-P -c" # simple colors
# Java for pyspark
export JAVA_HOME="/usr/lib/jvm/java-20-openjdk"

export PATH="$HOME/.local/bin:$PATH"
# for custom nvim install location
# export PATH="$HOME/neovim/bin:$PATH"

# Go
# GOPATH default is already $HOME/go
export GOPATH="$HOME/go"
# if GOBIN set, binaries installed there (not set by default)
# otherwise, install to $GOPATH/bin
export GOBIN="$GOPATH/bin"
# export PATH=$PATH:/usr/local/go/bin # from go install directions, but instead we're using ~/.go/bin

# for convenience; adds ~/go/bin to path
export PATH="$PATH:$(go env GOBIN)"
# export PATH="$PATH:$(go env GOBIN):$(go env GOPATH)/bin" # only necessary if they differ

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# aliases
# alias nvim-min="NVIM_APPNAME=nvim_min nvim" # alt nvim config
alias ..="cd .."
alias exti="exit"
alias ls="eza -a --icons --color=always --group-directories-first" # nicer ls
alias ll="eza -lah --icons --color=always --group-directories-first"
alias tree="ls -lh --tree --level=2"
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias grep="grep --color=auto"
alias tv="tidy-viewer"
alias keys="bash ~/.local/bin/keyboard-settings.sh"
alias ffetch="fastfetch"
alias R="R --no-save" # never prompt to save workspace image
alias ve="source .venv/bin/activate"
alias de="deactivate"
alias yz="yazi"
alias fd="fd --hidden --color never"
# git aliases
alias gs="git status"
alias ga="git add"
alias gb="git branch -v"
alias gc="git commit"
alias gco="git checkout"
alias gd="git diff"
alias gds="git diff --staged" # staged changes
alias gdh="git diff HEAD~" # diff latest commit with previous
alias gdd="git -P diff" # temp disable delta
alias gu="git rm --cached" # stop tracking given file
alias gl="git log --stat"
alias glp="git log --pretty=format:'%C(bold blue)%h%C(reset) - %C(green)%an%C(reset), %C(magenta)%as%C(reset)(%C(yellow)%ar%C(reset)): %s %C(auto)%d%C(reset)'"
alias glg="glp --graph --all"
alias gu="git restore --staged" # recommended undo for staged file

# functions
ff() {
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
# mkdir -p and cd automatically
mkd() {
    [[ "$1" ]] && mkdir -p "$1" && cd "$1"
}
# tt() {
#     ~/.local/bin/tmux-sessionizer.sh
# }
# change wezterm bg on the fly
# w() {
#     # uses just fzf
#     # ~/.local/bin/wezterm-bg-config.sh
#     # uses charm's gum
#     ~/.local/bin/wezterm-bg
# }
# wezterm logs appear here
wez-logs() {
    cd /run/user/1000/wezterm
    ls
}
wez-plugs() {
    cd ~/.local/share/wezterm/plugins
    ls
}
dots() {
    cd ~/.dotfiles
}
# for Obsidian vault
obs() {
    cd ~/Documents/obsidian-vault
    git status
}
# show journalctl for rclone backup service
bk() {
    journalctl --user -fu rclone_backup.service -n 30
}

# from fzf community
alias glNoGraph='git log --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr% C(auto)%an" "$@"'
_gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
_viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show --color=always % | delta'"
# fcoc_preview - checkout git commit with previews
fcoc_preview() {
  local commit
  commit=$( glNoGraph |
    fzf --no-sort --reverse --tiebreak=index --no-multi \
        --ansi --preview="$_viewGitLogLine" ) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}
# gshow - git commit browser with previews
gshow() {
    glNoGraph |
        fzf --no-sort --reverse --tiebreak=index --no-multi \
            --ansi --preview="$_viewGitLogLine" \
                --header "enter to view, alt-y to copy hash" \
                --bind "enter:execute:$_viewGitLogLine   | less -R" \
                --bind "alt-y:execute:$_gitLogLineToHash | xclip"
}
# checkout git branch
gbs() {
    local branches branch
    branches=$(git --no-pager branch -vv) &&
    branch=$(echo "$branches" | fzf +m) &&
    git checkout $(echo "$branch" | awk '{print $!}' | sed "s/.* //")
}

# fzf
source /usr/share/fzf/key-bindings.zsh # fzf keybinds
source /usr/share/fzf/completion.zsh # fzf fuzzy completion
# export FZF_DEFAULT_OPTS="--height 40%
#     --layout reverse
#     --preview 'bat --theme=base16 --color always {}'
#     --no-separator
#     --preview-window '50%'
#     --color=fg:#c0caf5,bg:-1,hl:underline:#9d7cd8 \
#     --color=fg+:#c0caf5,bg+:#283457,hl+:underline:#7dcfff \
#     --color=info:#ff9e64,prompt:#9d7cd8,pointer:#c0caf5
#     --color=marker:#9ece6a,spinner:#9ece6a
#     --color=gutter:-1,border:#7aa2f7,header:-1
#     --color=preview-fg:#c0caf5,preview-bg:-1"
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

# nvm - removed b/c too slow
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # loads nvm
# source /usr/share/nvm/init-nvm.sh # from Arch wiki

# fnm
# `--use-on-cd` flag will automatically run `fnm use` when a dir contains a `.node-version` or `.nvmrc` file
# `--version-file-strategy=recursive` might also make sense; default is local
# using both = auto use/install the right Node version when going into proj subdirs and moving between proj
eval "$(fnm env --use-on-cd)"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH" # from pyenv section on zsh
eval "$(pyenv init -)"

unsetopt beep autocd
setopt hist_ignore_all_dups # delete old even if new one is dup
setopt hist_ignore_dups
setopt hist_save_no_dups
setopt hist_expire_dups_first
setopt hist_ignore_space # ignore commands that start with space
setopt share_history # share hist between sessions

bindkey -v
export KEYTIMEOUT=1
bindkey -v "^?" backward-delete-char # make vi backspace like vim backspace
bindkey "^H" backward-kill-word # ctrl-backspace to del word

zmodload zsh/complist # need for menuselect; load before compinit
autoload -U compinit && compinit # autocompletion system
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey "^F" expand-or-complete # inititate completion menu
_comp_options+=(globdots) # include hidden files in completion
setopt MENU_COMPLETE # on ambiguous completion insert first match and cycle thru rest
setopt AUTO_LIST # on ambiguous, automatically list
setopt COMPLETE_IN_WORD # tries to complete from either end of the word

zstyle ':completion:*' completer _extensions _complete _approximate # which completers to use
zstyle ':completion:*' menu select # menu-based completion
zstyle ':completion:*' complete-options true # autocomplete for cd
zstyle ':completion:*' file-sort modification # ordering of names (mod time)
zstyle ':completion:*' rehash true
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' keep-prefix true # try to keep tilde or param expansions
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # use colors for completing

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey "^I" autosuggest-accept # tab to accept suggestion (zsh-autosuggestions)
eval "$(zoxide init zsh)" # zoxide; keep at end
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # keep at end
source ~/.config/wezterm/wezterm.sh
eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/omp_config.toml)"
# zprof
