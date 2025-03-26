#!/bin/bash

# From Chromebook Nautilus Desktop project: https://github.com/ghodulik95/chromebook-nautilus-desktop
# This project is not affiliated or endorsed by Google or Samsung

# This code listens for tablet-mode enable/disable events from the
# laptop hinges. It appears to activate when rotated about 300 degrees -
#  unsure if that sensing is customizable or finer-grained but I find it more
#  than suffices.
# The device names can vary across boots, so xinput list and libinput list-devices
# is used to get the correct ids before starting the listening job.
# libinput list-devices requires sudo, so you can add passwordless
# sudo to this script with sudo visudo to not have to enter your password
# each login. See documentation for more details.

# Find internal keyboard ID dynamically
KEYBOARD_ID=$(xinput list | grep 'AT Translated Set 2 keyboard' | grep -o 'id=[0-9]*' | cut -d= -f2)

if [ -z "$KEYBOARD_ID" ]; then
    echo "Keyboard not found"
    exit 1
fi

# More accurate way to detect the tablet mode switch device
SWITCH_DEVICE=$(libinput list-devices | awk '
  BEGIN { found=0 }
  /^Device:.*Tablet Mode Switch/ { found=1 }
  found && /^Kernel:/ { print $2; exit }
')

if [ -z "$SWITCH_DEVICE" ]; then
    echo "Tablet mode switch device not found"
    exit 1
fi

echo "Listening for tablet mode events on $SWITCH_DEVICE..."
echo "Keyboard ID is $KEYBOARD_ID"

# Start monitoring for switch events
libinput debug-events --device "$SWITCH_DEVICE" | while read -r line; do
    if echo "$line" | grep -q 'switch tablet-mode state 1'; then
        echo "Tablet mode ON - disabling keyboard (id $KEYBOARD_ID)"
        xinput disable "$KEYBOARD_ID"
        notify-send -u low "Tablet Mode" "ON – Keyboard disabled"
    elif echo "$line" | grep -q 'switch tablet-mode state 0'; then
        echo "Tablet mode OFF - enabling keyboard (id $KEYBOARD_ID)"
        xinput enable "$KEYBOARD_ID"
        notify-send -u low "Tablet Mode" "OFF – Keyboard enabled"
    fi
done
