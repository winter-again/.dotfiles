#!/usr/bin/env bash

# from inside "$(bat --config-dir)/themes":
curl -O https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_night.tmTheme
bat cache --build
echo '--theme="tokyonight_night"' >> "$(bat --config-dir)/config"
