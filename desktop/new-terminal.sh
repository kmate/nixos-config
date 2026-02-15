#!/usr/bin/env bash

# Get the active window class and size
active_window=$(hyprctl activewindow -j)
active_class=$(echo "$active_window" | jq -r '.class')

# Check if we're in Ghostty terminal
if [[ "$active_class" == "com.mitchellh.ghostty" ]]; then
  # We're in Ghostty, determine split direction based on window dimensions
  width=$(echo "$active_window" | jq -r '.size[0]')
  height=$(echo "$active_window" | jq -r '.size[1]')
  
  # Split in the direction with more space (like Hyprland's auto-tiling)
  if [[ $width -gt $height ]]; then
    ghostty +new-split:right
  else
    ghostty +new-split:down
  fi
else
  # Not in terminal, open a new Ghostty window
  ghostty
fi
