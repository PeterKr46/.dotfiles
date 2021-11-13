#!/bin/bash

player=$(cat "/home/$USER/.config/i3/player_target")
[[ -n $player && $(playerctl -l) == *"$player"* ]] || player=$(playerctl -l | head -1)

select_control () {
    selected=$(playerctl -l | rofi -dmenu -p "Select Player")
    echo ${selected:=$player} > "/home/$USER/.config/i3/player_target"
}

use_control() {
    playerctl $1 -p $2
}

[[ -z $1 ]] && select_control || use_control $1 $player
