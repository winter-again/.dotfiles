#!/usr/bin/env bash

# INSTALL_LOC="$HOME/neovim"

tokyonight_fg="#c0caf5"
tokyonight_blue="#7aa2f7"
tokyonight_purple="#9d7cd8"

# based on https://github.com/rebelot/dotfiles/blob/4d4f8dbb3d999cc03ccf2881ca091f0c7a040c5f/neovim-update
# limit it to building either stable or nightly releases
cd "$HOME/Documents/code/neovim" || exit

# note: not foolproof because have to manually intervene if build fails since repo is up-to-date

# commit hash of latest commit on origin/master
# before and after fetch
current_origin_master="$(git --no-pager log origin/master -n 1 --pretty=format:"%H")"
current_stable="$(git rev-list --max-count=1 stable)"
current_nightly="$(git rev-list --max-count=1 nightly)"
# include all tags and force updt changes for tags like stable and nightly
git fetch --tags --force
latest_origin_master="$(git --no-pager log origin/master -n 1 --pretty=format:"%H")"
latest_stable="$(git rev-list --max-count=1 stable)"
latest_nightly="$(git rev-list --max-count=1 nightly)"

gum style \
    --border rounded \
    --border-foreground $tokyonight_blue \
    --padding "1 1" \
    "Current <master/origin>: $current_origin_master" \
    "Latest <master/origin>: $latest_origin_master" \
    "" \
    "Current <stable>: $current_stable" \
    "Latest <stable>: $latest_stable" \
    "" \
    "Current <nightly>: $current_nightly" \
    "Latest <nightly>: $latest_nightly"

tag_choice=$(
    gum choose \
        --header="Choose a tag to checkout and build" \
        --limit 1 \
        --cursor.foreground=$tokyonight_purple \
        --header.foreground=$tokyonight_blue \
        --item.foreground=$tokyonight_fg \
        "stable" "nightly"
)

if [[ $tag_choice == "stable" ]] && [[ $current_stable != "$latest_stable" ]]; then
    git pull
    git checkout stable
    make CMAKE_BUILD_TYPE=RelWithDebInfo && sudo make install
elif [[ $tag_choice == "nightly" ]] && [[ $current_nightly != "$latest_nightly" ]]; then
    git pull
    git checkout nightly
    make CMAKE_BUILD_TYPE=RelWithDebInfo && sudo make install
else
    echo "Neovim (at that release) is already up to date..."
fi
