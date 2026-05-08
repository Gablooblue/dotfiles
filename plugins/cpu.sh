#!/usr/bin/env bash

# Lightweight CPU info using sysctl (no expensive `top` call)
LOAD_AVG=$(sysctl -n vm.loadavg 2>/dev/null | awk '{print $2}')

if [[ -n "$LOAD_AVG" ]]; then
  sketchybar --set "$NAME" label="$LOAD_AVG" icon="󰻠"
else
  sketchybar --set "$NAME" label="--" icon="󰻠"
fi
