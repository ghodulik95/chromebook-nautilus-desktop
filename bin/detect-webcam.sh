#!/bin/bash

# From Chromebook Nautilus Desktop project: https://github.com/ghodulik95/chromebook-nautilus-desktop
# This project is not affiliated or endorsed by Google or Samsung

# The device name for the webcam can vary across boots.
# (It is some variation of /dev/video*, but given that
#  there are over a dozen virtual camera feeds, it can
#  bounce around quite a bit)
# This script parses v4l2-ctl output to identify the
# path and make a symlink to /dev/webcam.
# Running this script is not required for most webcam
# applications, but if you have code that relies on a static
# device link across boots, running this script on autostart should
# suffice in ensuring /dev/webcam always links to the webcam.

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
