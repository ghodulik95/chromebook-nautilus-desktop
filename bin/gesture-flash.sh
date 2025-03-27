#!/bin/bash

# From Chromebook Nautilus Desktop project: https://github.com/ghodulik95/chromebook-nautilus-desktop
# Disclaimer: This project is not affiliated with or endorsed by Google or Samsung.

# Description:
# Mimics Google Chrome's Back/Forward/Refresh swipe animations using a transparent-like overlay.
# Implemented via a yad window showing a Unicode symbol with a background color sampled
# from the window content beneath it. Because yad doesn’t support transparency,
# we simulate it by sampling the background and using a fading animation.

# Usage: ./script_name.sh [left|right|refresh]
DIRECTION="$1"

# Array of opacity levels for animation (from opaque to fully transparent)
OPACITIES=(
    0xffffffff  # fully opaque
    0xf0f0f0f0
    0xe0e0e0e0
    0xd0d0d0d0
    0xc0c0c0c0
    0xb0b0b0b0
    0xa0a0a0a0
    0x90909090
    0x80808080
    0x70707070
    0x60606060
    0x50505050
    0x40404040
    0x30303030
    0x20202020
    0x10101010
    0x00000000  # fully transparent
)

# Choose Unicode symbol based on direction
TEXT="←"
if [ "$DIRECTION" = "right" ]; then
  TEXT="→"
elif [ "$DIRECTION" = "refresh" ]; then
  TEXT="⟳"
fi

# Get geometry of currently focused window
eval $(xdotool getactivewindow getwindowgeometry --shell)
WINDOW_X=${X}
WINDOW_Y=${Y}
WINDOW_WIDTH=${WIDTH}
WINDOW_HEIGHT=${HEIGHT}

# Determine overlay position and background sample location based on direction
if [ "$DIRECTION" = "right" ]; then
  ARROW_X=$((WINDOW_X + 10))
  ARROW_Y=$((WINDOW_Y + WINDOW_HEIGHT / 2 - 50))
  SAMPLE_X=$((ARROW_X + 50))  # sample to the right of the window's left edge
  SAMPLE_Y=$((ARROW_Y))
elif [ "$DIRECTION" = "refresh" ]; then
  ARROW_X=$((WINDOW_X + WINDOW_WIDTH / 2 - 50))
  ARROW_Y=$((WINDOW_Y + WINDOW_HEIGHT / 10 + 20))
  SAMPLE_X=$((ARROW_X))
  SAMPLE_Y=$((ARROW_Y + 50))  # sample below the window's top edge
else  # left
  ARROW_X=$((WINDOW_X + WINDOW_WIDTH - 60))
  ARROW_Y=$((WINDOW_Y + WINDOW_HEIGHT / 2 - 50))
  SAMPLE_X=$((ARROW_X + 50))  # sample to the left of the window's right edge
  SAMPLE_Y=$((ARROW_Y))
fi

# Capture a small section of the screen at the sample location to extract color
import -window root -crop 30x30+"$SAMPLE_X"+"$SAMPLE_Y" /tmp/capture.png

# Extract average RGB color from blurred sample for matching background
COLOR=$(convert /tmp/capture.png \
    -colorspace RGB \
    -blur 0x4 \
    -colors 3 \
    -resize 1x1\! \
    -format "%[pixel:p{0,0}]" info:)

# Parse R, G, B values from output like srgb(123,234,56)
R=$(echo "$COLOR" | grep -oP 'srgb\(\K\d+')
G=$(echo "$COLOR" | grep -oP ',\K\d+' | head -1)
B=$(echo "$COLOR" | grep -oP ',\K\d+' | tail -1)

# Convert RGB to hex string for Pango color
PANGO_COLOR=$(printf "#%02x%02x%02x" "$R" "$G" "$B")

# Launch the overlay window with styled text at computed position
yad --text="<span font_desc='Liberation Sans Narrow 35' rise='1000' background='$PANGO_COLOR'><b>$TEXT</b></span>" \
    --no-buttons \
    --undecorated \
    --skip-taskbar \
    --on-top \
    --timeout=1 \
    --borders=0 \
    --text-align=center \
    --no-focus \
    --fixed \
    --posx="$ARROW_X" \
    --posy="$ARROW_Y" &

YAD_PID=$!

# Attempt to get Yad window ID (for animation) quickly after launch
for i in {1..10}; do
    YAD_WIN_ID=$(xdotool search --sync --pid "$YAD_PID" | tail -1)
    if [ -n "$YAD_WIN_ID" ]; then
        break
    fi
    sleep 0.05
done

# Animate if window ID was found
if [ -n "$YAD_WIN_ID" ]; then

    START_X="$ARROW_X"
    START_Y="$ARROW_Y"

    for i in "${!OPACITIES[@]}"; do
        OPACITY="${OPACITIES[$i]}"

        NEW_X="$START_X"
        NEW_Y="$START_Y"

        # Animate in the specified direction
        case "$DIRECTION" in
            left)
                NEW_X=$((START_X - 2*i))
                ;;
            right)
                NEW_X=$((START_X + 2*i))
                ;;
            refresh)
                NEW_Y=$((START_Y + 2*i))
                ;;
        esac

        # Move the overlay and apply fading opacity
        xdotool windowmove "$YAD_WIN_ID" "$NEW_X" "$NEW_Y"
        xprop -id "$YAD_WIN_ID" -f _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY "$OPACITY"
        sleep 0.01
    done

    # Cleanup overlay
    kill "$YAD_PID" 2>/dev/null
else
    echo "Could not find Yad window ID for opacity fade"
fi
