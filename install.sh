#!/usr/bin/env bash

function check_stow() {
    if ! hash stow > /dev/null 2>&1; then
        echo "Stow not found"
        exit 1
    else
        echo "Stow found"
    fi
}

check_stow

# install dotfiles below
echo "Installing dotfiles..."
stow --target "$HOME" --no-folding autorandr
stow --target "$HOME" --no-folding bat
stow --target "$HOME" betterlockscreen
stow --target "$HOME" --no-folding dunst
stow --target "$HOME" --no-folding fonts
stow --target "$HOME" git
stow --target "$HOME" --no-folding i3
stow --target "$HOME" lintr
stow --target "$HOME" --no-folding nvim
stow --target "$HOME" --no-folding picom
stow --target "$HOME" --no-folding polybar
stow --target "$HOME" --no-folding radian
stow --target "$HOME" --no-folding rofi
stow --target "$HOME" --no-folding rstudio
stow --target "$HOME" --no-folding scripts
stow --target "$HOME" starship
stow --target "$HOME" --no-folding themes
stow --target "$HOME" tidy-viewer
stow --target "$HOME" --no-folding wezterm
stow --target "$HOME" x
stow --target "$HOME" zsh
