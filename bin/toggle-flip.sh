#!/bin/bash

# Flips the nautilus screen vertically.
# Untested when there are additional connected displays.

# === CONFIGURATION ===
# Use `xinput list` to get the correct id if this is not it.
# Note that Elan Touchpad, which you will probably also see, is the
# touchpad, not the touchscreen.
# If you plan to use the touchpad while the screen is flipped you
# may want to do a similar transformation for the touchpad.
TOUCH_DEVICE_NAME="SYTS7813:00 06CB:7813"

# === GET PRIMARY DISPLAY ===
output=$(xrandr | grep ' connected primary' | awk '{ print $1 }')

# === GET CURRENT ROTATION (normalize value) ===
rotation=$(xrandr | grep " connected primary" | grep -oP '\S+\s(?=\()' | cut -d' ' -f1 | xargs)

# Fallback in case the rotation is malformed
if [[ "$rotation" != "normal" && "$rotation" != "inverted" ]]; then
    rotation="normal"
fi

# === TOGGLE SCREEN AND TOUCH INPUT ===
if [[ "$rotation" == "normal" ]]; then
    xrandr --output "$output" --rotate inverted
    xinput set-prop "$TOUCH_DEVICE_NAME" "Coordinate Transformation Matrix" -1 0 1 0 -1 1 0 0 1
    echo "Rotated to inverted and updated touchscreen."
else
    xrandr --output "$output" --rotate normal
    xinput set-prop "$TOUCH_DEVICE_NAME" "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1
    echo "Rotated to normal and restored touchscreen."
fi
