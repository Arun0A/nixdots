#!/bin/sh

# Get current volume and mic status
volume=$(pamixer --get-volume)%$(pamixer --get-mute | grep -q true && echo " [MUTE]" || echo "")
micmark=$(pactl get-source-mute @DEFAULT_SOURCE@ | grep -q yes && echo " " || echo "*")

# Write the current volume to /tmp/status_vol (for backup)
echo "$volume" >/tmp/status_vol

# Read the base status from /tmp/status_base
base=$(cat /tmp/status_base 2>/dev/null || echo "")

# Set the full status with mic mark and volume, and keep base info
xsetroot -name "${micmark}${volume} | $base"
