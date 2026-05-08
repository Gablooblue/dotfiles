#!/usr/bin/env bash

# Window title plugin - updates on app switch and workspace change

if [ "$SENDER" = "front_app_switched" ]; then
  APP_NAME="$INFO"
elif [ "$SENDER" = "aerospace_workspace_change" ]; then
  APP_NAME=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)
else
  APP_NAME=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)
fi

if [[ -n "$APP_NAME" && "$APP_NAME" != "missing value" ]]; then
  sketchybar --set "$NAME" label="$APP_NAME" drawing=on
else
  sketchybar --set "$NAME" label="" drawing=off
fi
