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

# Define the path to the serial ID of MCU
SERIAL_FILE="/home/biqu/printer_data/config/MCU_serial.cfg"
CONFIG_FILE="/home/biqu/printer_data/config/0__Marathon/.9__Formbot__MCU_Flash/MCU_config/BTT_Manta_M8P_V1.1/.config"

# Extract the serial ID from the serial file
SERIAL_ID=$(grep "serial:" "$SERIAL_FILE" | awk '{print $2}')

# Check if the configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Configuration file $CONFIG_FILE does not exist!"
    exit 1
fi

# Check if the serial ID was successfully extracted
if [ -z "$SERIAL_ID" ]; then
    echo "Could not find serial ID in $SERIAL_FILE!"
    exit 1
fi

# Take the config suited for mainboard
cp -f /home/biqu/printer_data/config/0__Marathon/.9__Formbot__MCU_Flash/MCU_config/BTT_Manta_M8P_V1.1/.config /home/biqu/klipper/

# Go to the Klipper directory
cd /home/biqu/klipper/

# Delete the old config and make a new one
make olddefconfig
make clean
make

# Flash the firmware to the MCU
echo "Flashing the firmware..."

# Stop the Klipper service
#echo "$PASSWORD" | sudo -S service klipper stop

# Flash the firmware with sudo
echo "$PASSWORD" | sudo -S make flash FLASH_DEVICE="$SERIAL_ID"

sleep 5

service klipper restart

echo "Firmware flashing complete."





