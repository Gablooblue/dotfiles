#!/usr/bin/env bash

# Detect active Zoom meeting and whether Granola is recording
# CptHost is Zoom's meeting host process — only exists during active calls

IN_MEETING=false

# Check for Zoom meeting via CptHost process
if pgrep -x CptHost >/dev/null 2>&1; then
  IN_MEETING=true
fi

if [[ "$IN_MEETING" != "true" ]]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

# In a meeting — check if Granola is running
if pgrep -x Granola >/dev/null 2>&1; then
  # Granola is running, all good
  sketchybar --set "$NAME" \
    icon="󰍬" \
    label="Recording" \
    icon.color=0xff30d158 \
    label.color=0xff30d158 \
    drawing=on
else
  # In meeting WITHOUT Granola — warning
  sketchybar --set "$NAME" \
    icon="󰀦" \
    label="Start Granola!" \
    icon.color=0xffff453a \
    label.color=0xffff453a \
    drawing=on
fi
