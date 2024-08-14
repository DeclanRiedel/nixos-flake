#!/usr/bin/env bash

#Change directory to ~/Dropbox/ObsidianDropbox/newNotes or exit if unsuccessful
cd ~/Dropbox/ObsidianDropbox/newNotes || exit

# Ensure an argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

# Filename provided as argument
filename="$1"

# Current date in day-month-year format
current_date=$(date +%d-%m-%Y)

# Combine filename with current date
file_with_date="${filename}_${current_date}"

# Open Neovim with a specific command
nvim +ObsidianTemplate "${file_with_date}.md"
