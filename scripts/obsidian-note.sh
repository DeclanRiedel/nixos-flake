#!/usr/bin/env bash

# Check if the user provided a title
if [ $# -eq 0 ]; then
  echo "Usage: $0 \"title including spaces\""
  exit 1
fi

# Capture the entire title (all arguments)
title="$*"

# Define the base directory for your notes
base_dir="$HOME/obsidian/00_Notes/Unsorted/"

# Construct the full file path with the title
file_path="$base_dir/$title.md"

# Use nvim with the constructed path
nvim +ObsidianTemplate "$file_path"
