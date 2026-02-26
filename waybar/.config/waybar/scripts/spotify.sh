#!/usr/bin/env bash

# json output should look like
# {"text": "$text", "alt": "$alt", "tooltip": "$tooltip", "class": "$class", "percentage": "$percentage"}
# on single line
# removed the markup_escape() calls because it'd show apostrophe as "&apos;"
playerctl --player=spotify --follow metadata \
    --format '{"text": "{{ artist }} | {{ title }}", "tooltip": "<span color=\"#8f8aac\"><b>{{ album }}</b></span> \nTrack {{ xesam:trackNumber }} [{{ duration(position) }}/{{ duration(mpris:length) }}]", "alt": "{{ status }}", "class": "{{ lc(status) }}"}'
