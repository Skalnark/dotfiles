#!/usr/bin/env bash

# Add this script to your wm startup file.

DIR="$HOME/.config/polybar"
HDMI1=$(xrandr --query | grep 'HDMI1')

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the bar

if [[ $DUAL_MONITOR ]]; then
	polybar -q main -c "$DIR"/config.ini &
	polybar -q external -c "$DIR"/config.ini &
else
	polybar -q single -c "$DIR"/config.ini &
fi
