#!/usr/bin/env bash

url="$1"
# NOTE: covers playlist URLs too
yt-dlp -x -f bestaudio \
-o "%(artist)s - %(title)s" \
--embed-metadata \
--no-embed-chapters \
--no-embed-info-json \
--no-write-playlist-metafiles \
--no-overwrites \
--parse-metadata "playlist_index:%(track_number)s" \
"$url"
