#!/bin/bash
xdotool type $(cat /home/$USER/.config/emoji-picker/emoji-simple.txt | rofi -dmenu -matching glob | awk '{ print $1 }')
