#!/usr/bin/env bash

RUNNING=$(osascript -e 'application "Spotify" is running' 2>/dev/null)

if [[ "$RUNNING" != "true" ]]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

STATE=$(osascript -e 'tell application "Spotify" to player state as string' 2>/dev/null)

if [[ "$STATE" != "playing" ]]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

TRACK=$(osascript -e 'tell application "Spotify" to name of current track as string' 2>/dev/null)
ARTIST=$(osascript -e 'tell application "Spotify" to artist of current track as string' 2>/dev/null)

# Truncate long strings
DISPLAY="$ARTIST — $TRACK"
if [[ ${#DISPLAY} -gt 50 ]]; then
  DISPLAY="${DISPLAY:0:47}..."
fi

sketchybar --set "$NAME" label="$DISPLAY" icon="󰓇" drawing=on
