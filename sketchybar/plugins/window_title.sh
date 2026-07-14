#!/usr/bin/env bash

# Shows the title of the currently focused window (AeroSpace).
# Subscribed to `front_app_switched` and `aerospace_workspace_change`.

MAX_LEN=80

TITLE=$(aerospace list-windows --focused --format '%{app-name} — %{window-title}' 2>/dev/null)

# Trim trailing " — " when window-title is empty.
TITLE="${TITLE% — }"

if [ -z "$TITLE" ]; then
  sketchybar --set "$NAME" label.drawing=off
  exit 0
fi

if [ "${#TITLE}" -gt "$MAX_LEN" ]; then
  TITLE="${TITLE:0:$MAX_LEN}…"
fi

sketchybar --set "$NAME" label="$TITLE" label.drawing=on
