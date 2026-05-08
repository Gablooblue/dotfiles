#!/usr/bin/env bash

# AeroSpace workspace indicator plugin for SketchyBar
# Triggered by: aerospace_workspace_change event

FOCUSED_COLOR=0xff007aff    # macOS blue accent
OCCUPIED_COLOR=0xffe0e0e0
EMPTY_COLOR=0xff808080

FOCUSED_WS=$(aerospace list-workspaces --focused 2>/dev/null)

OCCUPIED_WORKSPACES=$(aerospace list-windows --all --format '%{workspace}' 2>/dev/null \
  | sort -u \
  | tr -d ' ')

for i in 1 2 3 4 5 6 7 8 9 10; do
  if [ "$i" = "$FOCUSED_WS" ]; then
    sketchybar --set space.$i \
      background.color=$FOCUSED_COLOR \
      background.drawing=on \
      label.color=0xffffffff \
      icon.color=0xffffffff
  elif echo "$OCCUPIED_WORKSPACES" | grep -qx "$i"; then
    sketchybar --set space.$i \
      background.color=0x00000000 \
      background.drawing=on \
      label.color=$OCCUPIED_COLOR \
      icon.color=$OCCUPIED_COLOR
  else
    sketchybar --set space.$i \
      background.color=0x00000000 \
      background.drawing=on \
      label.color=$EMPTY_COLOR \
      icon.color=$EMPTY_COLOR
  fi
done
