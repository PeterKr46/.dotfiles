#!/bin/bash

# Configuration

# On my system, the backlight simply offers a file handle - this might be different on yours.
backlight_file=/sys/class/backlight/intel_backlight/brightness

backlight_min=1
backlight_max=900
backlight_step=25

# I picked a pre-installed icon for my notifications.
backlight_icon=/usr/share/icons/HighContrast/256x256/status/display-brightness.png

# "back-end" function
brightness () {
    state=$(cat $backlight_file)
    if [ ! -z $1 ]; then 
        if [ $1 = down ]; then
            state=$(($state - backlight_step < backlight_min ? backlight_min : state - backlight_step))
        elif [ $1 = up ]; then
            state=$(($state + backlight_step > backlight_max ? backlight_max : state + backlight_step))
        fi
        echo $state > $backlight_file
    fi
}


brightness $1

# Send a notification
notify-send "Brightness" -i $backlight_icon "$(~/.config/i3/bar $state $backlight_min $backlight_max)" -h string:x-canonical-private-synchronous:anything
