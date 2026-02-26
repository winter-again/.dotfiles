#!/usr/bin/env bash

# json outputshould look like
# {"text": "$text", "alt": "$alt", "tooltip": "$tooltip", "class": "$class", "percentage": "$percentage"}
# on single line
playerctl --player=spotify --follow metadata \
    --format '{"text": "{{ artist }} | {{ markup_escape(title) }}", "tooltip": "<b>{{ markup_escape(album) }}</b> \nTrack {{ xesam:trackNumber }} [{{ duration(position) }}/{{ duration(mpris:length) }}]", "alt": "{{ status }}", "class": "{{ lc(status) }}"}'
