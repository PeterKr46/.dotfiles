#!/bin/bash

player=$(cat "/home/$USER/.config/i3/player_target")
[[ -n $player && $(playerctl -l) == *"$player"* ]] || player=$(playerctl -l | head -1)

select_control () {
    options=$(playerctl -l)
    num_options=$(echo $options | wc -w)
    preselect=$(echo "$(playerctl -l | grep -n $player | cut -f1 -d:)-1" | bc)
    selected=$(playerctl -l | rofi -dmenu -hide-scrollbar -width 12 -window-format t:10 -lines $num_options -selected-row $preselect -p "Select Player" -theme-str 'inputbar { enabled: false;}')
    echo ${selected:=$player} > "/home/$USER/.config/i3/player_target"
}

use_control() {
    playerctl -p "$@"
}

[[ -z $1 ]] && select_control || use_control $player "$@"
