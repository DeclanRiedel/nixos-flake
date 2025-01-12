#!/usr/bin/env bash

# Define directories and template path
JOURNAL_DIR="$HOME/Dropbox/zettelkasten/7 - Journal/"

TEMPLATE_FILE="$HOME/Dropbox/zettelkasten/5 - Template/Daily.md"

# Get current date in DD-MM-YYYY format
TODAY=$(date +%d-%m-%Y)

# Define the journal file path
JOURNAL_FILE="$JOURNAL_DIR/$TODAY.md"

# Create the journal file if it doesn't exist
if [[ ! -f "$JOURNAL_FILE" ]]; then
    if [[ -f "$TEMPLATE_FILE" ]]; then
        cp "$TEMPLATE_FILE" "$JOURNAL_FILE"
    else
        echo "# $TODAY" > "$JOURNAL_FILE"
        echo "Template file not found. Created a blank journal entry."
    fi
fi

# Open the journal file with your preferred editor
"${EDITOR:-nvim}" "$JOURNAL_FILE"
