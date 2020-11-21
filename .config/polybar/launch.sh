#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar with multi-monitor support
if type "xrandr"; then
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
#        MONITOR=$m polybar --reload topleft-laptop &
#        MONITOR=$m polybar --reload topright-laptop &
         MONITOR=$m polybar --reload topleft-desktop &
         MONITOR=$m polybar --reload topright-desktop &
    done
else
#    polybar --reload topleft-laptop &
#    polybar --reload topright-laptop &
     polybar --reload topleft-desktop &
     polybar --reload topleft-desktop &
fi