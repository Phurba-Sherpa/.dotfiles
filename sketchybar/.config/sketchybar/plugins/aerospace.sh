#!/usr/bin/env bash

if [ "$AEROSPACE_FOCUSED_WORKSPACE" = "${NAME#space.}" ]; then
  sketchybar --set "$NAME" label.color=0xffebdbb2 background.drawing=on
else
  sketchybar --set "$NAME" label.color=0x77ebdbb2 background.drawing=off
fi
