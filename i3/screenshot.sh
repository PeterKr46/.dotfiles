#!/bin/bash

icon="/usr/share/icons/HighContrast/48x48/apps/applets-screenshooter.png"

directory="/home/$USER/Pictures/"
filename=$(date +"%b%d-%Y-%H%M%S").png

maim $directory$filename
notify-send -i $icon "Screenshot saved." $filename 
