#!/usr/bin/env bash

# Configuration
DOWNLOAD_DIR="$HOME/Music/downloads"
LOG_FILE="$DOWNLOAD_DIR/failed_downloads.txt"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Function to log errors
log_error() {
    local search_query="$1"
    local error="$2"
    echo "[$TIMESTAMP] Failed to download: $search_query" >> "$LOG_FILE"
    echo "Search Query: $search_query" >> "$LOG_FILE"
    echo "Error: $error" >> "$LOG_FILE"
    echo "----------------------------------------" >> "$LOG_FILE"
}

# Function to check if playerctl is running
check_playerctl() {
    if ! command -v playerctl &> /dev/null; then
        notify-send "Error" "playerctl is not installed"
        exit 1
    fi
}

# Function to get media metadata
get_metadata() {
    local title artist
    
    title=$(playerctl metadata title 2>/dev/null)
    artist=$(playerctl metadata artist 2>/dev/null)

    if [ -z "$title" ]; then
        notify-send "Error" "No title found. Is anything playing?"
        exit 1
    fi

    # Combine title and artist for better search results
    if [ -n "$artist" ]; then
        echo "$title - $artist"
    else
        echo "$title"
    fi
}

# Create necessary directories
mkdir -p "$DOWNLOAD_DIR"

# Check dependencies
check_playerctl

if ! command -v yt-dlp &> /dev/null; then
    notify-send "Error" "yt-dlp is not installed"
    exit 1
fi

# Get metadata
SEARCH_QUERY="$(get_metadata)"

# Start download with progress notification
notify-send "Starting Download" "Searching for: $SEARCH_QUERY"

# Temporary file for capturing yt-dlp output
TEMP_OUTPUT=$(mktemp)

# Attempt download using ytsearch
if yt-dlp -x --audio-format mp3 \
    --output "$DOWNLOAD_DIR/%(title)s.%(ext)s" \
    --format bestaudio \
    "ytsearch1:$SEARCH_QUERY" 2>"$TEMP_OUTPUT"; then
    
    # Success
    notify-send "Download Complete" "Saved to Music/downloads\n${SEARCH_QUERY}"
else
    # Failed download
    ERROR_MSG=$(cat "$TEMP_OUTPUT")
    notify-send "Download Failed" "Check failed_downloads.txt for details"
    log_error "$SEARCH_QUERY" "$ERROR_MSG"
fi

# Clean up
rm -f "$TEMP_OUTPUT"

# Check available disk space
AVAILABLE_SPACE=$(df -h "$DOWNLOAD_DIR" | awk 'NR==2 {print $4}')
if [[ $(df "$DOWNLOAD_DIR" | awk 'NR==2 {print $4}') -lt 1048576 ]]; then  # Less than 1GB
    notify-send "Warning" "Low disk space: $AVAILABLE_SPACE remaining"
fi

# Check if downloads folder is getting too large (>10GB)
FOLDER_SIZE=$(du -sh "$DOWNLOAD_DIR" | cut -f1)
if [[ $(du -b "$DOWNLOAD_DIR" | cut -f1) -gt 10737418240 ]]; then
    notify-send "Warning" "Downloads folder is large: $FOLDER_SIZE"
fi 
