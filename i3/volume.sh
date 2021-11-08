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
    muted=""
    [[ $state -gt 30 ]] && icon=$icon_medium
    [[ $state -gt 70 ]] && icon=$icon_high
    if [[ -z $(amixer sget "$target_control" | grep "\[on\]") ]]; then
        icon=$icon_muted
        muted="barely"
    fi
    
    notify-send "Volume $state%" -i $icon "$(~/.config/i3/bar $state 0 100 35 $muted)" -h string:x-canonical-private-synchronous:audio
}

volume $1
notify
