#!/usr/bin/env bash

# Check if directory argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <music_directory>"
    exit 1
fi

MUSIC_DIR="$1"

# Check if directory exists
if [ ! -d "$MUSIC_DIR" ]; then
    echo "Error: Directory does not exist"
    exit 1
fi

# Create a log file for errors
LOG_FILE="$MUSIC_DIR/organization_errors.txt"
echo "Starting organization at $(date)" > "$LOG_FILE"

# Process each MP3 file
find "$MUSIC_DIR" -maxdepth 1 -type f -name "*.mp3" | while read -r file; do
    # Extract artist from metadata using ffprobe
    artist=$(ffprobe -v quiet -show_entries format_tags=artist -of default=noprint_wrappers=1:nokey=1 "$file")
    
    # If no metadata found, try extracting from filename (assuming "Title - Artist.mp3" format)
    if [ -z "$artist" ]; then
        filename=$(basename "$file")
        if [[ $filename == *" - "* ]]; then
            artist=$(echo "$filename" | cut -d'-' -f2 | sed 's/\.mp3$//' | sed 's/^ *//;s/ *$//')
        fi
    fi
    
    # If still no artist, move to "Unknown Artist" folder
    if [ -z "$artist" ]; then
        artist="Unknown Artist"
        echo "No artist found for: $file" >> "$LOG_FILE"
    fi
    
    # Clean artist name for directory
    artist_dir=$(echo "$artist" | tr -d '/<>:"|?*\\')
    
    # Create artist directory if it doesn't exist
    target_dir="$MUSIC_DIR/$artist_dir"
    mkdir -p "$target_dir"
    
    # Move file to artist directory with original filename
    original_filename=$(basename "$file")
    mv "$file" "$target_dir/$original_filename"
    echo "Moved: $file -> $target_dir/$original_filename"
done

echo "Organization complete. Check $LOG_FILE for any errors."
