#\!/usr/bin/env bash

# Screenshot script for Hyprland with grim + slurp
selection=$(slurp 2>/dev/null)
if [ $? -eq 0 ]; then
    grim -g "$selection" - | wl-copy
    notify-send "Screenshot" "Screenshot copied to clipboard" -t 2000
else
    notify-send "Screenshot" "Screenshot cancelled" -t 2000
fi
EOF < /dev/null