#!/bin/bash

# Extract the parameters


# Extract SSID and password values from parameters
WIFI_SSID=$(echo "$1" | cut -d '=' -f 2-)
WIFI_PASSWD=$(echo "$2" | cut -d '=' -f 2-)

# Check if both SSID and PASSWORD are provided
if [ -z "$WIFI_SSID" ] || [ -z "$WIFI_PASSWD" ]; then
  echo "SSID and PASSWORD must be provided."
  exit 1
fi

# Create a new connection profile
nmcli device wifi connect "$WIFI_SSID" password "$WIFI_PASSWD"

# Ensure the connection is set to autoconnect
nmcli connection modify "$WIFI_SSID" connection.autoconnect yes

echo "WiFi setup completed for SSID: $WIFI_SSID"