#!/bin/bash

TARGET_LABEL="720p HD Camera"
LINK_NAME="/dev/webcam"

# Grab the first /dev/video* entry under the matching device block
DEVICE=$(v4l2-ctl --list-devices | awk -v RS= -v label="$TARGET_LABEL" '
  $0 ~ label {
    for (i = 1; i <= NF; i++) {
      if ($i ~ /\/dev\/video[0-9]+/) {
        print $i
        exit
      }
    }
  }
')

if [ -n "$DEVICE" ]; then
    sudo ln -sf "$DEVICE" "$LINK_NAME"
    echo "Linked $DEVICE -> $LINK_NAME"
else
    echo "Webcam '$TARGET_LABEL' not found"
fi
