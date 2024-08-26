#!/usr/bin/env bash

DIR="$HOME/Dropbox/ObsidianDropbox/Journal"
DATE=$(date +"%d-%m-%Y")
FILENAME="$DIR/$DATE.md"

mkdir -p "$DIR"

if [[ -f "$FILENAME" ]]; then
    nvim "$FILENAME"
else
    nvim +ObsidianTemplate "$FILENAME"
fi
