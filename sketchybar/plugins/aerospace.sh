#!/usr/bin/env bash

# Re-paints a space.N item to reflect the currently focused AeroSpace workspace.
# Invoked on the `aerospace_workspace_change` event (env: AEROSPACE_FOCUSED_WORKSPACE)
# and at startup when sketchybar fires the item's script for the first time.

ACCENT_COLOR=0xff007aff
TEXT_COLOR=0xffe0e0e0
DIM_COLOR=0xff808080
FOCUSED_FG=0xffffffff
INACTIVE_BG=0x00000000

# Item name is "space.N"; extract N.
WS="${NAME#space.}"

# Prefer the env var from the trigger; fall back to querying aerospace.
FOCUSED="${AEROSPACE_FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

if [ "$WS" = "$FOCUSED" ]; then
  BG=$ACCENT_COLOR
  FG=$FOCUSED_FG
else
  BG=$INACTIVE_BG
  FG=$DIM_COLOR
fi

sketchybar --set "$NAME" \
  background.color="$BG" \
  label.color="$FG" \
  icon.color="$FG"
