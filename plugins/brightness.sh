#!/usr/bin/env bash

# Get brightness via ioreg (built-in, no deps)
# Try Apple Silicon first, then Intel
BSTR=$(ioreg -c AppleARMBacklight -r 2>/dev/null | grep -o '"brightness"={[^}]*}' | head -1)
if [[ -z "$BSTR" ]]; then
  BSTR=$(ioreg -c AppleBacklightDisplay -r 2>/dev/null | grep -o '"brightness"={[^}]*}' | head -1)
fi

if [[ -n "$BSTR" ]]; then
  VALUE=$(echo "$BSTR" | grep -o '"value"=[0-9]*' | grep -o '[0-9]*')
  MAX=$(echo "$BSTR" | grep -o '"max"=[0-9]*' | grep -o '[0-9]*')

  if [[ -n "$VALUE" && -n "$MAX" && "$MAX" -gt 0 ]]; then
    PERCENT=$(( VALUE * 100 / MAX ))
  fi
fi

# Fallback: try `brightness` CLI (Homebrew)
if [[ -z "$PERCENT" ]] && command -v brightness &>/dev/null; then
  PERCENT=$(brightness -l 2>/dev/null | grep -o '[0-9]*\.[0-9]*' | head -1 | awk '{printf "%d", $1 * 100}')
fi

if [[ -z "$PERCENT" ]]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

case "$PERCENT" in
  [7-9][0-9]|100) ICON="󰃠" ;;
  [3-6][0-9])     ICON="󰃟" ;;
  *)              ICON="󰃞" ;;
esac

sketchybar --set "$NAME" icon="$ICON" label="${PERCENT}%" drawing=on
