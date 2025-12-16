#!/bin/bash
# ==========================================================
#   POLYBAR PLAYER STATUS SCRIPT
#   Shows currently playing media (Spotify, Firefox, etc)
#   Requires: playerctl
# ==========================================================

# Check if playerctl is installed
if ! command -v playerctl &> /dev/null; then
    echo "No player"
    exit 0
fi

# Get player status
status=$(playerctl status 2>/dev/null)

if [ "$status" = "Playing" ]; then
    artist=$(playerctl metadata artist 2>/dev/null)
    title=$(playerctl metadata title 2>/dev/null)
    
    # Truncate long titles (max 30 chars)
    if [ ${#title} -gt 30 ]; then
        title="${title:0:27}..."
    fi
    
    # Show artist - title if artist exists, otherwise just title
    if [ -n "$artist" ]; then
        echo "$artist - $title"
    else
        echo "$title"
    fi
elif [ "$status" = "Paused" ]; then
    echo "Paused"
else
    echo ""
fi
