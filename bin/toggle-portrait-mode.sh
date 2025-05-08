#!/bin/bash

# From Chromebook Nautilus Desktop project: https://github.com/ghodulik95/chromebook-nautilus-desktop
# This project is not affiliated or endorsed by Google or Samsung

# Detects touchscreen and primary display.
# Cycles between normal, left, and right to allow for portrait mode.
# Touchscreen input changes to reflect new orientation.
# Using with external displays connected seems to mostly work, but can sometimes
# cause the touchscreen to behave unexpectedly.

# === CONFIGURATION ===
TOUCH_MATCH='SYTS|06CB'
touch_id=$(xinput list | grep -iE "$TOUCH_MATCH" | head -n1 | grep -oP 'id=\K\d+')

if [[ -z "$touch_id" ]]; then
    echo "Error: No touchscreen device matching pattern '$TOUCH_MATCH' found."
    echo -e "\n💡 Troubleshooting tips:"
    echo "  • Run: xinput list"
    echo "  • Update TOUCH_MATCH in this script to match your touchscreen device"
    echo "  • Or hardcode the correct device ID manually, e.g., touch_id=8"
    exit 1
fi

# === GET PRIMARY DISPLAY ===
output=$(xrandr | awk '/ connected primary/ {print $1}')

# === CHECK FOR EXTERNAL DISPLAY ===
external_display_count=$(xrandr | grep ' connected' | grep -v "$output" | wc -l)
if (( external_display_count > 0 )); then
    echo "⚠️ External display detected. Touchscreen may misbehave."
    notify-send "Screen rotation warning: External display detected" "This could cause the touchscreen to misbehave." -u normal
fi

# === GET CURRENT ROTATION ===
rotation=$(xrandr | grep "$output connected" | grep -oP '\S+\s(?=\()' | awk '{print $1}')
case "$rotation" in
    normal|left|right) ;; # acceptable values
    *) rotation="normal" ;;
esac

# === DEFINE ROTATION ORDER AND TRANSFORM MATRICES ===
case "$rotation" in
    normal)
        next_rotation="left"
        matrix="0 -1 1 1 0 0 0 0 1"
        ;;
    left)
        next_rotation="right"
        matrix="0 1 0 -1 0 1 0 0 1"
        ;;
    right)
        next_rotation="normal"
        matrix="1 0 0 0 1 0 0 0 1"
        ;;
esac

# === APPLY ROTATION ===
echo "Rotating display: $rotation → $next_rotation"
xrandr --output "$output" --rotate "$next_rotation"
xinput set-prop "$touch_id" "Coordinate Transformation Matrix" $matrix
xinput map-to-output "$touch_id" "$output"
echo "Touchscreen matrix updated for $next_rotation orientation."
