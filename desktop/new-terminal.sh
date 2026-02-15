#!/usr/bin/env bash

# Get the active window class and address
active_window=$(hyprctl activewindow -j)
active_class=$(echo "$active_window" | jq -r '.class')

# Check if we're in Ghostty terminal
if [[ "$active_class" == "com.mitchellh.ghostty" ]]; then
  # We're in Ghostty, alternate split direction per window
  # Use window address to track state per window
  window_addr=$(echo "$active_window" | jq -r '.address')
  state_file="/tmp/ghostty-last-split-$window_addr"
  
  if [[ -f "$state_file" ]] && [[ "$(cat "$state_file")" == "right" ]]; then
    # Last split was right, now split down
    wtype -M logo -M shift -P d -m shift -m logo -p d
    echo "down" > "$state_file"
  else
    # Last split was down or first split, now split right
    wtype -M logo -P d -m logo -p d
    echo "right" > "$state_file"
  fi
else
  # Not in terminal, open a new Ghostty window
  ghostty
fi
