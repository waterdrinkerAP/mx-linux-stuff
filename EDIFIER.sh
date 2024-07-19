#!/usr/bin/env bash

deviceName="EDIFIER Headset"
deviceMac="CC:14:BC:49:C3:25"
iconPath="/usr/share/icons/Adwaita/32x32/devices/bluetooth-symbolic.symbolic.png"
timeoutSeconds=15  # Set the timeout period (in seconds)

# Function to send notifications
notify() {
  notify-send --icon=$iconPath "$1"
}

# Remove the device if present
bluetoothctl remove $deviceMac
notify "Please make sure $deviceName is in pairing mode."

# Scan for the device until it is found or timeout occurs
deviceFound=false
endTime=$((SECONDS + timeoutSeconds))

bluetoothctl scan on &
scan_pid=$!

while [ $SECONDS -lt $endTime ]; do
  if bluetoothctl devices | grep -q "$deviceMac"; then
    deviceFound=true
    break
  fi
  sleep 1
done

bluetoothctl scan off
kill $scan_pid

if [ "$deviceFound" = true ]; then
  connection_output=$(bluetoothctl connect $deviceMac)

  if [[ $connection_output = *'not available'* ]]; then
    notify "Pairing unsuccessful. Please try again later."
  else
    notify "Pairing successful. Connected to $deviceName."

    # Extract the sink name associated with the device MAC address
    sinkName=$(pactl list sinks | grep -B 20 "$deviceMac" | grep 'Name:' | awk '{print $2}')

    # Set the default sink using the extracted sink name
    if [ -n "$sinkName" ]; then
      pactl set-default-sink "$sinkName"
      notify "Changed output device to $deviceName."
    else
      notify "Failed to find sink for $deviceName."
    fi
  fi
else
  notify "Device $deviceName not found within the timeout period. Please try again later."
fi
