#!/usr/bin/env bash

sid="${NAME#space.}"
FOCUSED=$(aerospace list-workspaces --focused)

# Show if focused OR non-empty
if [ "$sid" = "$FOCUSED" ] || aerospace list-workspaces --monitor all --empty no | grep -qx "$sid"; then
  sketchybar --set "$NAME" drawing=on
else
  sketchybar --set "$NAME" drawing=off
fi

# Focus highlight
if [ "$sid" = "$FOCUSED" ]; then
  sketchybar --set "$NAME" label.color=0xffebdbb2 background.drawing=on
else
  sketchybar --set "$NAME" label.color=0x77ebdbb2 background.drawing=off
fi
