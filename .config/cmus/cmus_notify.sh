#!/bin/env bash

#status=$(playerctl status)
status=$(cmus-remote -Q | grep status | awk '{print $2}')
title=$(cmus-remote -C "format_print %t")
song_path=$(cmus-remote -C "format_print %f")
#ffmpeg -y -i $song_path /tmp/cmus_cover.fifo > /dev/null 2>&1
ffmpeg -y -i "$song_path" -filter:v scale=-2:250 -an /tmp/cmus_cover.jpg

if [ "$status" = playing ]; then
	info=$(cmus-remote -C "format_print %a\ -\ %l")
	notify-send -u low -i /tmp/cmus_cover.jpg --hint=string:x-dunst-stack-tag:cmus "$title" "$info"
elif [ "$status" = paused ]; then
	formatted=$(cmus-remote -C "format_print \ Paused:\ %{position}/%d")
	notify-send -u low -i /tmp/cmus_cover.jpg --hint=string:x-dunst-stack-tag:cmus "$title" "$formatted"
fi

# Tell cover script to update
echo upd >/tmp/cmus_cover.jpg

# # It's scrobblin' time
# cmusfm "$@"
