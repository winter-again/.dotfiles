#!/usr/bin/env bash

set -e

loc=$(tmux run "echo #{pane_start_path}")
url=$(git -C "$loc" remote get-url origin)
clean_url=$(echo "$url" | sed 's/\(git@github\.com:\)\(.*\)\(\.git\)/https:\/\/github.com\/\2/')

xdg-open "$clean_url"
