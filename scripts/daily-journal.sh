!/usr/bin/env bash

# Define the directory and filename
DIR="$HOME/Dropbox/ObsidianDropbox/Journal"
DATE=$(date +"%d-%m-%Y")
FILENAME="$DIR/$DATE.md"

# Ensure the directory exists
mkdir -p "$DIR"

# Check if the file already exists
if [[ -f "$FILENAME" ]]; then
  nvim "$FILENAME" 
else
    nvim +ObsidianTemplate "$FILENAME"
fi

