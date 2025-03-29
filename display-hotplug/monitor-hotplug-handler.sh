#!/bin/bash

export DISPLAY=:0
xrandr | grep "\HDMI-1\b.\connected\b" >>/dev/null
echo "xrandr run"
if [ "$?" -eq "0" ]; then
  xrandr --output HDMI-1 --auto --left-of eDP-1 --rotate left
  notify-send "HDMI-1 connected"
  echo "connected"
else
  xrandr --auto
  notify-send "HDMI-1 disconnected"
  echo "disconnected"
fi
