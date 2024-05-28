#!/bin/bash

# Define the path to the password file
PASSWORD_FILE="/home/biqu/printer_data/config/.system_pass.txt"

# Check if the password file exists
if [ ! -f "$PASSWORD_FILE" ]; then
    echo "Password file $PASSWORD_FILE does not exist!"
    exit 1
fi

# Read the password from the file
PASSWORD=$(cat "$PASSWORD_FILE")


# Extract the parameters

# Extract Continent and City values from parameters
CONTINENT=$(echo "$1" | cut -d '=' -f 2-)
CITY=$(echo "$2" | cut -d '=' -f 2-)

# Check if both CONTINENT and PASSWORD are provided
if [ -z "$CONTINENT" ] || [ -z "$CITY" ]; then
  echo "CONTINENT and CITY must be provided."
  exit 1
fi

# Setup Time Zone using system password
echo "$PASSWORD" | sudo -S timedatectl set-timezone "$CONTINENT"/"$CITY"

echo "Time Zone setup completed for: $CONTINENT / $CITY"