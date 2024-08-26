#!/usr/bin/env bash

# Define the target directory
TARGET_DIR="$HOME/Dropbox/ObsidianDropbox/quick-notes"

# Change directory to the target or exit if unsuccessful
if ! cd "$TARGET_DIR"; then
    echo "Error: Unable to change to directory $TARGET_DIR"
    exit 1
fi

# Ensure an argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

# Filename provided as argument (use all arguments to allow spaces in filename)
filename="$*"

# Remove any file extension if provided
filename="${filename%.*}"

# Current date in day-month-year format
current_date=$(date +%d-%m-%Y)

# Combine filename with current date
file_with_date="${filename}_${current_date}"

# Sanitize filename (remove special characters except underscore and hyphen)
file_with_date=$(echo "$file_with_date" | sed 's/[^a-zA-Z0-9_-]/_/g')

# Append .md extension
full_filename="${file_with_date}.md"

# Check if file already exists
if [ -e "$full_filename" ]; then
    echo "Warning: File $full_filename already exists. Opening existing file."
    nvim "$full_filename"
else
    # Open Neovim with a specific command
    if ! nvim +ObsidianTemplate "$full_filename"; then
        echo "Error: Failed to open Neovim"
        exit 1
    fi
fi
