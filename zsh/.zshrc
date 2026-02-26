#!/bin/sh
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
#######################
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space # ignore commands that start with space
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export SHELL=/bin/zsh
export EDITOR="nvim"
export VISUAL="nvim"
export PATH="$HOME/.local/bin:$PATH" # for zoxide and others

# zap
#[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
#plug "zsh-users/zsh-autosuggestions"
## plug "marlonrichert/zsh-autocomplete"
#plug "zsh-users/zsh-syntax-highlighting"
#plug "hlissner/zsh-autopair"
## plug "jeffreytse/zsh-vi-mode"
## plug "zsh-users/zsh-history-substring-search"
#plug "zsh-users/zsh-completions"
#plug "zap-zsh/completions"

# aliases
# some taken from zap-zsh proj (https://github.com/zap-zsh)
alias ls="eza -a --icons --color=always --group-directories-first" # nicer ls
alias ll="eza -lah --icons --color=always --group-directories-first"
alias tree="ls -lh --tree --level=2"
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias grep="grep --color=auto"
alias tv="tidy-viewer"
alias keys="bash ~/.local/bin/keyboard_settings.sh"

# git aliases
alias gs="git status"
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

# other tools
eval "$(zoxide init zsh)" # zoxide
source /usr/share/fzf/key-bindings.zsh # fzf keybinds for zsh
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
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
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
    --header 'Press CTRL-Y to copy command into clipboard'"
# nvm
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
source /usr/share/nvm/init-nvm.sh # since using AUR pkg

# functions
ff() {
    local dir
    dir=$(fd . \
        ~/Documents/Bansal_lab \
        ~/Documents/projects \
        ~/Documents/projects/nvim-dev
        --min-depth 1 --max-depth 1 --type d | fzf --no-preview)
    cd "$dir"
}
tt() {
    ~/.local/bin/tmux-sessionizer.sh
}
# use fd and fzf to jump to dirs in .dotfiles
dot() {
    local dir
    dir=$(fd . ~/.dotfiles/ --max-depth 3 --type d --hidden --exclude .git | fzf --no-preview)
    cd "$dir"
}
dots() {
    cd ~/.dotfiles
}
# for Obsidian vault
obs() {
    if [ $(pwd) != "~/Documents/andrew-obsidian/" ]
    then
        cd ~/Documents/andrew-obsidian
    fi
    git status
}
# show journalctl for rclone backup service
bk() {
    journalctl -u rclone_backup.service -n 30
}
# https://github.com/junegunn/fzf/wiki/Examples#changing-directory
cdf() {
    local dir
    dir=$(find ${1:-.} -path '*/\.*' -prune \
        -o -type d -print 2> /dev/null | fzf +m) &&
    cd "$dir"
}
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
# Java for pyspark
export JAVA_HOME="/usr/lib/jvm/java-20-openjdk"

################################
# starship (keep at end of file)
# to set starship, just uncomment line below and then comment out the p10k stuff at top
# and below
# eval "$(starship init zsh)"

# p10k
# source ~/powerlevel10k/powerlevel10k.zsh-theme
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

unsetopt autocd beep
autoload -Uz colors && colors
autoload -U compinit && compinit
_comp_options+=(globdots) # include hidden files in completion
setopt MENU_COMPLETE # on ambiguous completion insert first match and cycle thru rest
setopt AUTO_LIST # on ambiguous automatically list
setopt COMPLETE_IN_WORD # tries to complete from either end
zstyle ':completion:*' complete-options true # autocomplete for cd
zstyle ':completion:*' file-sort modification # ordering of names (mod time)
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' menu select # menu-based completion
zstyle ':completion:*' rehash true
# layers of completion to try in succession
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' keep-prefix true # try to keep tilde or param expansions
# keybinds
bindkey -e
bindkey "^I" autosuggest-accept # tab to accept
bindkey "^F" expand-or-complete # inititate completion menu

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
