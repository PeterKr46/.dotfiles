#!/bin/bash

player=$(cat "/home/$USER/.config/i3/player_target")
[[ -z $player || $(playerctl -ls) != *"$player"* ]] && player=$(playerctl -ls | head -1)

select_control () {
    options=$(playerctl -ls)
    if [[ -z $options ]]; then
        notify-send "Media Keys" "No active players." -h string:category:device.error -i dialog-error
        return 0
    fi
    num_options=$(echo $options | wc -w)
    preselect=$(echo "$(playerctl -ls | grep -n $player | cut -f1 -d:)-1" | bc)
    selected=$(playerctl -ls | rofi -dmenu -hide-scrollbar -width 12 -window-format t:10 -lines $num_options -selected-row $preselect -p "Select Player" -theme-str 'inputbar { enabled: false;}')
    echo ${selected:=$player} > "/home/$USER/.config/i3/player_target"
}

use_control() {
    [[ -z $(playerctl -ls) ]] || playerctl -p "$@"
}

[[ -z $1 ]] && select_control || use_control $player "$@"
