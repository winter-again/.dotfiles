#!/usr/bin/env bash

# json outputshould look like
# {"text": "$text", "alt": "$alt", "tooltip": "$tooltip", "class": "$class", "percentage": "$percentage"}
# on single line
# removed the markup_escape() calls because it'd show apostrophe as "&apos;"
playerctl --player=spotify --follow metadata \
    --format '{"text": "{{ artist }} | {{ title }}", "tooltip": "<b>{{ album }}</b> \nTrack {{ xesam:trackNumber }} [{{ duration(position) }}/{{ duration(mpris:length) }}]", "alt": "{{ status }}", "class": "{{ lc(status) }}"}'
