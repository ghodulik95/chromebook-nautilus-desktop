#!/bin/bash

# Direction: "left" or "right"
DIRECTION="$1"
TEXT="←"
# Array of opacity levels (hex)
# Moving here to hopefully cut a couple ms of the start of the fade
OPACITIES=(
    0xffffffff  # full opacity
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


if [ "$DIRECTION" = "right" ]; then
  TEXT="→"
elif [ "$DIRECTION" = "refresh" ]; then
  TEXT="⟳"
fi

# Get focused window geometry
eval $(xdotool getactivewindow getwindowgeometry --shell)
WINDOW_X=${X}
WINDOW_Y=${Y}
WINDOW_WIDTH=${WIDTH}
WINDOW_HEIGHT=${HEIGHT}

# Position arrow based on direction
if [ "$DIRECTION" = "right" ]; then
  ARROW_X=$((WINDOW_X))
  ARROW_Y=$((WINDOW_Y + WINDOW_HEIGHT / 2 - 50))
elif [ "$DIRECTION" = "refresh" ]; then
  ARROW_X=$((WINDOW_X + WINDOW_WIDTH / 2 - 50))
  ARROW_Y=$((WINDOW_Y + WINDOW_HEIGHT / 10 - 10))
else  # left
  ARROW_X=$((WINDOW_X + WINDOW_WIDTH - 155))
  ARROW_Y=$((WINDOW_Y + WINDOW_HEIGHT / 2 - 50))
fi

# Capture a small region under the future yad window
import -window root -crop 30x30+"$ARROW_X"+"$ARROW_Y" /tmp/capture.png

# Get the average color from the resized 1x1 image
COLOR=$(convert /tmp/capture.png -resize 1x1\! -format "%[pixel:p{0,0}]" info:)

# Extract R, G, B values
R=$(echo "$COLOR" | grep -oP 'srgb\(\K\d+')
G=$(echo "$COLOR" | grep -oP ',\K\d+' | head -1)
B=$(echo "$COLOR" | grep -oP ',\K\d+' | tail -1)

# Format to hex
PANGO_COLOR=$(printf "#%02x%02x%02x" "$R" "$G" "$B")

# Show the overlay
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

# Try to find the window quickly
for i in {1..10}; do
    YAD_WIN_ID=$(xdotool search --sync --pid "$YAD_PID" | tail -1)
    if [ -n "$YAD_WIN_ID" ]; then
        break
    fi
    sleep 0.05
done

# If found, apply fade-out animation with directional movement
if [ -n "$YAD_WIN_ID" ]; then

    START_X="$ARROW_X"
    START_Y="$ARROW_Y"

    for i in "${!OPACITIES[@]}"; do
        OPACITY="${OPACITIES[$i]}"

        # Default to original position
        NEW_X="$START_X"
        NEW_Y="$START_Y"

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

        xdotool windowmove "$YAD_WIN_ID" "$NEW_X" "$NEW_Y"
        xprop -id "$YAD_WIN_ID" -f _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY "$OPACITY"
        sleep 0.01
    done

    kill "$YAD_PID" 2>/dev/null
else
    echo "Could not find Yad window ID for opacity fade"
fi



