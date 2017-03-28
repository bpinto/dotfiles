#!/bin/sh

# Allow X apps to be opened with browser user
xhost si:localuser:browser

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
xrandr --dpi 240
exec i3
