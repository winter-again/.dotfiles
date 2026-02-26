#!/usr/bin/env bash

BAT_CONFIG=$(bat --config-dir)

mkdir "$BAT_CONFIG"/themes
cd "$BAT_CONFIG"/themes
curl -O https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_night.tmTheme
bat cache --build
echo '--theme="tokyonight_night"' >> "$BAT_CONFIG/config"
