#!/bin/bash

# From Chromebook Nautilus Desktop project: https://github.com/ghodulik95/chromebook-nautilus-desktop
# This project is not affiliated or endorsed by Google or Samsung

# Detects touchscreen and primary display.
# Flips primary display vertically and transforms
# touchscreen input to reflect new orientation.
# Not tested when external monitors are connected.

# === GET TOUCHSCREEN ===
# Regex ideally will make this work across slight model differences
TOUCH_MATCH='SYTS|06CB'
touch_id=$(xinput list | grep -iE "$TOUCH_MATCH" | head -n1 | grep -oP 'id=\K\d+')

if [[ -z "$touch_id" ]]; then
    echo "Error: No touchscreen device matching pattern '$TOUCH_MATCH' was found."
    echo ""
    echo "💡 Try one of the following:"
    echo "  • Run: xinput list    # to view all input devices"
    echo "  • Look for your touchscreen (e.g., SYTS####)"
    echo "  • Update TOUCH_MATCH in the script to better match your device"
    echo "  • Or, hardcode the correct device name or id manually"
    echo ""
    echo "Example: change"
    echo '  TOUCH_MATCH="SYTS|06CB"'
    echo "to something like"
    echo '  TOUCH_MATCH="SYTS7813:00 06CB:7813"'
    echo "or use"
    echo '  touch_id=8  # if you know the correct ID'
    exit 1
fi


# === GET PRIMARY DISPLAY ===
output=$(xrandr | grep ' connected primary' | awk '{ print $1 }')

# === GET CURRENT ROTATION (normalize value) ===
rotation=$(xrandr | grep " connected primary" | grep -oP '\S+\s(?=\()' | cut -d' ' -f1 | xargs)

# Fallback in case the rotation is malformed or not present
if [[ "$rotation" != "normal" && "$rotation" != "inverted" ]]; then
    rotation="normal"
fi

# === TOGGLE SCREEN AND TOUCH INPUT ===
if [[ "$rotation" == "normal" ]]; then
    xrandr --output "$output" --rotate inverted
    xinput set-prop "$touch_id" "Coordinate Transformation Matrix" -1 0 1 0 -1 1 0 0 1
    echo "Rotated to inverted and updated touchscreen."
else
    xrandr --output "$output" --rotate normal
    xinput set-prop "$touch_id" "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1
    echo "Rotated to normal and restored touchscreen."
fi
