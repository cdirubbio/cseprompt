#!/bin/bash
SCRIPT_NAME="promptgen.sh"
INSTALL_PATH="/usr/local/bin/cseprompt"

# Check if script exists in current directory
if [ ! -f "$SCRIPT_NAME" ]; then
    echo "Error: $SCRIPT_NAME not found in current directory"
    exit 1
fi

# Make the script executable
chmod +x "$SCRIPT_NAME"

# Move the script to /usr/local/bin
if ! sudo cp "$SCRIPT_NAME" "$INSTALL_PATH"; then
    echo "Failed to copy script to $INSTALL_PATH"
    exit 1
fi

echo "Installation complete! You can now use 'cseprompt' command anywhere."
echo "Try 'cseprompt --help' to get started."
