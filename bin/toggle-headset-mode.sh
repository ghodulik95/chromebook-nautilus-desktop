#!/bin/bash

# Automatically toggle Bluetooth headset profile between A2DP and HSP
# Fails gracefully if no device is connected or profile not supported

# Get the first connected bluez card
CARD=$(pactl list cards short | grep bluez_card | awk '{print $1}' | head -n 1)

if [ -z "$CARD" ]; then
  notify-send "No Bluetooth headset found" "Make sure it's connected."
  exit 1
fi

# Get current profile
CURRENT_PROFILE=$(pactl list cards | awk "/$CARD/,/Active Profile/" | grep "Active Profile" | awk -F ": " '{print $2}')

# Define profiles
MIC_PROFILE="headset-head-unit"
AUDIO_PROFILE="a2dp-sink"

# Toggle logic
if [ "$CURRENT_PROFILE" == "$AUDIO_PROFILE" ]; then
  NEW_PROFILE="$MIC_PROFILE"
  MODE="Microphone mode (HSP/HFP)"
else
  NEW_PROFILE="$AUDIO_PROFILE"
  MODE="High-quality audio mode (A2DP)"
fi

# Try switching
if pactl set-card-profile "$CARD" "$NEW_PROFILE"; then
  notify-send "Bluetooth Profile Switched" "$MODE"
else
  notify-send "Failed to switch profile" "Profile '$NEW_PROFILE' not supported"
  exit 2
fi
