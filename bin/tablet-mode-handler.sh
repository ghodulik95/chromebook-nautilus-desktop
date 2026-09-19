#!/bin/bash

# From Chromebook Nautilus Desktop project:
# https://github.com/ghodulik95/chromebook-nautilus-desktop
# This project is not affiliated or endorsed by Google or Samsung

# This code listens for tablet-mode enable/disable events from the
# laptop hinges and disables/enables the internal keyboard and touchpad.

# Find internal keyboard ID dynamically
KEYBOARD_ID=$(
    xinput list |
    grep 'AT Translated Set 2 keyboard' |
    grep -o 'id=[0-9]*' |
    cut -d= -f2
)

if [ -z "$KEYBOARD_ID" ]; then
    echo "Keyboard not found"
    exit 1
fi

# Find internal touchpad ID(s) dynamically.
#
# This intentionally searches case-insensitively for "touchpad" rather than
# assuming one exact device name.
TOUCHPAD_IDS=$(
    xinput list |
    grep -i 'touchpad' |
    grep -o 'id=[0-9]*' |
    cut -d= -f2
)

if [ -z "$TOUCHPAD_IDS" ]; then
    echo "Warning: touchpad not found"
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

if [ -n "$TOUCHPAD_IDS" ]; then
    echo "Touchpad ID(s): $TOUCHPAD_IDS"
fi

PIPE_PATH="/tmp/tabletmode.pipe"

disable_input_devices() {
    echo "Disabling keyboard (id $KEYBOARD_ID)"
    xinput disable "$KEYBOARD_ID"

    for id in $TOUCHPAD_IDS; do
        echo "Disabling touchpad (id $id)"
        xinput disable "$id"
    done
}

enable_input_devices() {
    echo "Enabling keyboard (id $KEYBOARD_ID)"
    xinput enable "$KEYBOARD_ID"

    for id in $TOUCHPAD_IDS; do
        echo "Enabling touchpad (id $id)"
        xinput enable "$id"
    done
}

# Ensure cleanup on logout/shutdown/CTRL+C
cleanup() {
    echo "Stopping tablet mode monitor"

    # Restore devices in case the script is stopped while tablet mode is active.
    enable_input_devices

    kill "$LIBINPUT_PID" 2>/dev/null
    rm -f "$PIPE_PATH"
    exit
}

trap cleanup SIGINT SIGTERM EXIT

# Ensure named pipe exists
[ -p "$PIPE_PATH" ] || mkfifo "$PIPE_PATH"

# Start libinput in background, writing to the named pipe
libinput debug-events --device "$SWITCH_DEVICE" > "$PIPE_PATH" &
LIBINPUT_PID=$!

# Start monitoring for switch events
while read -r line; do
    if echo "$line" | grep -q 'switch tablet-mode state 1'; then
        echo "Tablet mode ON"
        disable_input_devices
        notify-send -u low "Tablet Mode" "ON – Keyboard and touchpad disabled"

    elif echo "$line" | grep -q 'switch tablet-mode state 0'; then
        echo "Tablet mode OFF"
        enable_input_devices
        notify-send -u low "Tablet Mode" "OFF – Keyboard and touchpad enabled"
    fi
done < "$PIPE_PATH"
