#!/bin/bash

# Usage: volume.sh [up|down|mute]

# CONFIGURATION

# Target device in amixer - you might need to adjust this
# Run "amixer scontrols" for a list
target_control="Master"

# Percent to raise/lower each time
volume_step=5

# I picked some re-installed icons for my notifications
icon_path=/usr/share/icons/HighContrast/48x48/status

icon_high=$icon_path/audio-volume-high.png
icon_medium=$icon_path/audio-volume-medium.png
icon_low=$icon_path/audio-volume-low.png
icon_muted=$icon_path/audio-volume-muted.png

top_text="Volume"

playback_status() {
    for player in $(playerctl -l); do
        if [ $(playerctl status -p $player) = "Playing" ]; then
            track_title=$(playerctl -p $player metadata xesam:title )
            track_artist=$(playerctl -p $player metadata xesam:artist)
            [[ -z $track_artist ]] && track_artist="Unknown"
            track_album=$(playerctl -p $player metadata xesam:album)
            [[ -z $track_album ]] && track_album="Unknown"
           
            origin="$track_artist  –  $track_album"

            [[ ! -z ${origin:35:1} ]] && origin="${origin:0:32}..."
            [[ ! -z ${track_title:35:1} ]] && track_title="${track_title:0:32}..."
            [[ ! -z $track_title ]] && extra_text="\n\n<tt><b>$track_title</b>\n$origin</tt>"
       fi
   done
}

# "back-end" function
volume () {
    if [ ! -z $1 ]; then 
        if   [ $1 = mute ]; then
            amixer -q sset "$target_control" toggle
        elif [ $1 = up   ]; then
            amixer -q sset "$target_control" $volume_step%+
        elif [ $1 = down ]; then
            amixer -q sset "$target_control" $volume_step%-
        fi
    fi
    state=$(amixer sget "$target_control" | grep -Po "\[\K\d+" | head -n 1)
}

# "front-end" function
notify () {
    icon=$icon_low
    filled='#fff'
    empty='#333'
    [[ $state -gt 30 ]] && icon=$icon_medium
    [[ $state -gt 70 ]] && icon=$icon_high
    if [[ -z $(amixer sget "$target_control" | grep "\[on\]") ]]; then
        icon=$icon_muted
        filled='#999'
        empty='#333'
    fi
    bar=$(~/.config/i3/pango_bar $state 0 100 35 "$state%" $filled $empty)
    notify-send "$top_text" -i $icon "<tt>$bar</tt>$extra_text" -h string:x-canonical-private-synchronous:audio
}

volume $1
playback_status
notify
