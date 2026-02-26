#!/usr/bin/env bash

MUSIC_DIR="$HOME/Music/yt-dlp"
URL="$1"

# NOTE: handles single videos and playlists

args=(
    -x # audio only
    -f bestaudio # format choice
    -o "$MUSIC_DIR/%(artist&{} - |)s%(upload_date>%Y)s - %(album&{} - |)s%(track_number&{} |)s%(track,title)s.%(ext)s"
    --output-na-placeholder ""
    --no-embed-metadata # (default) don't add metadata
    --no-embed-chapters # (default) don't add chapter markers
    --no-embed-info-json # don't embed infojson
    --no-write-playlist-metafiles # only need if using --write-info-json or --write-description?
    --no-overwrites
    --parse-metadata "playlist_index:%(track_number)s" # use playlist index as the track nums
    "$URL"
)

yt-dlp "${args[@]}"
