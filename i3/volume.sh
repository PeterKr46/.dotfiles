#!/bin/bash

# Usage: volume.sh [up|down|mute]

# CONFIGURATION

# Target device in amixer - you might need to adjust this
# Run "amixer scontrols" for a list
target_control="Master"

# I picked some re-installed icons for my notifications
icon_path=/usr/share/icons/HighContrast/256x256/status

icon_high=$icon_path/audio-volume-high.png
icon_medium=$icon_path/audio-volume-medium.png
icon_low=$icon_path/audio-volume-low.png
icon_muted=$icon_path/audio-volume-muted.png


# "back-end" function
volume () {
    if [ ! -z $1 ]; then 
        if   [ $1 = mute ]; then
            amixer -q sset "$target_control" toggle
        elif [ $1 = up   ]; then
            amixer -q sset "$target_control" 5%+
        elif [ $1 = down ]; then
            amixer -q sset "$target_control" 5%-
        fi
    fi
    state=$(amixer sget "$target_control" | grep -Po "\[\K\d+" | head -n 1)
}

# "front-end" function
notify () {
    icon=$icon_low
    muted=""
    [[ $state -gt 30 ]] && icon=$icon_medium
    [[ $state -gt 70 ]] && icon=$icon_high
    if [[ -z $(amixer sget "$target_control" | grep "\[on\]") ]]; then
        icon=$icon_muted
        muted="barely"
    fi
    
    notify-send "Volume $state%" -i $icon "$(~/.config/i3/bar $state 0 100 37 $muted)" -h string:x-canonical-private-synchronous:anything
}

volume $1
notify
