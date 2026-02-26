#!/usr/bin/env bash

gum choose "fix" "feat" "docs" "style" "refactor" "test" "chore" "revert"
gum input --placeholder "scope"
gum input --placeholder "Summary of this change"
gum write --placeholder "Details of the change (ctrl+d to finish)"

gum confirm "Are you sure?" && echo "ALL DONE"
