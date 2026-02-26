#!/bin/sh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#######################

# p10k
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh # checks if ~/.p10k.zsh is setup

export HISTFILE=~/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000 # num of commands stored
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export TERM=wezterm # for undercurl supp
export SHELL=/bin/zsh
export EDITOR="nvim"
export VISUAL="nvim"
# Java for pyspark
export JAVA_HOME="/usr/lib/jvm/java-20-openjdk"
# Go
export GOPATH=$HOME/go # should already be default
export GOBIN="$GOPATH/bin" # should also be default
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin # loc of installed binaries
# export PATH="$HOME/.local/bin:$PATH" # for zoxide and others; don't think needed

# aliases
# alias nvim-min="NVIM_APPNAME=nvim_min nvim" # alt nvim config
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
alias neofetch="fastfetch"
alias R="R --no-save" # never prompt to save workspace image
# for starting rstudio with flags for Wayland; shouldn't need this now that the .desktop file works
# alias rstd="/usr/lib/rstudio/rstudio --disable-gpu --enable-features=UseOzonePlatform --ozone-platform=wayland &"
alias yz="yazi"
# git aliases
alias gs="git status"
alias ga="git add"
alias gco="git checkout"
alias gd="git diff"
alias gds="git diff --cached" # staged changes
alias gdc="git diff HEAD~" # diff latest commit with previous
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
            --min-depth 1 --max-depth 1 --type d | fzf --prompt=" Directory: " --no-preview)
    else
        dir=$(fd . \
            ~/Documents/Bansal-lab \
            ~/Documents/code \
            ~/Documents/code/nvim-dev \
            --min-depth 1 --max-depth 1 --type d | fzf-tmux -p --prompt=" Directory: " --no-preview)
    fi
    cd "$dir"
}
tt() {
    ~/.local/bin/tmux-sessionizer.sh
}
# change wezterm bg on the fly
ww() {
    ~/.local/bin/wezterm-bg-config.sh
}
# wezterm logs appear here
wez_logs() {
    cd /run/user/1000/wezterm
}
# use fd and fzf to jump to dirs in .dotfiles
dot() {
    local dir
    if [[ -z "${TMUX}" ]]; then
        dir=$(fd . ~/.dotfiles/ --max-depth 3 --type d --hidden --exclude .git | fzf --prompt="󱗿 Dotfiles: " --no-preview)
    else
        dir=$(fd . ~/.dotfiles/ --max-depth 3 --type d --hidden --exclude .git | fzf-tmux --prompt="󱗿 Dotfiles: " -p --no-preview)
    fi
    cd "$dir"
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
    journalctl --user -u rclone_backup.service -f -n 30
}


# fzf
source /usr/share/fzf/key-bindings.zsh # fzf keybinds
source /usr/share/fzf/completion.zsh # fzf fuzzy completion
export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --border=rounded --preview 'bat --theme=base16 --color=always {}' --preview-window '50%'
    --color=fg:#c0caf5,bg:#1a1b26,hl:#bb9af7
	--color=fg+:#c0caf5,bg+:#292e42,hl+:#7dcfff
	--color=info:#ff9e64,prompt:#7dcfff,pointer:#c0caf5
	--color=marker:#9ece6a,spinner:#9ece6a
    --color=gutter:#1a1b26,border:#27a1b9,header:#7aa2f7
    --color=preview-fg:#c0caf5,preview-bg:#16161e"
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

# nvm
export NVM_DIR="$HOME/.nvm"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH" # from pyenv section on zsh
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # loads nvm
source /usr/share/nvm/init-nvm.sh # from Arch wiki
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

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey "^I" autosuggest-accept # tab to accept suggestion (zsh-autosuggestions)
eval "$(zoxide init zsh)" # zoxide; keep at end
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # keep at end
