#!/usr/bin/env bash

# Configuration
DOWNLOAD_DIR="$HOME/Media/Music"
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

    if [ "$title" = "" ]; then
        notify-send "Error" "No title found. Is anything playing?"
        exit 1
    fi

    # Combine title and artist for better search results
    if [ "$artist" != "" ]; then
        echo "$title - $artist"
    else
        echo "$title"
    fi
}

# Function to check for duplicates
check_duplicate() {
    local search_query="$1"
    
    # Get exact YouTube title first
    local yt_title=$(yt-dlp --get-title "ytsearch1:$search_query" 2>/dev/null)
    
    if [ "$yt_title" = "" ]; then
        notify-send "Error" "Couldn't fetch video title"
        return 1
    fi
    
    # Check if file with exact title exists
    if [ -f "$DOWNLOAD_DIR/${yt_title}.mp3" ]; then
        notify-send "Duplicate Found" "Already exists:\n${yt_title}"
        return 0  # Duplicate found
    fi
    return 1  # No duplicate found
}

# Function to check duration before downloading
check_duration() {
    local search_query="$1"
    local max_duration=960  # 16 minutes in seconds
    
    # Get duration using yt-dlp
    local duration=$(yt-dlp --get-duration "ytsearch1:$search_query" 2>/dev/null | \
                    awk -F ':' '{if (NF==3) print ($1 * 3600) + ($2 * 60) + $3; 
                                else if (NF==2) print ($1 * 60) + $2; 
                                else print $1}')
    
    if [ "$duration" != "" ] && [ "$duration" -gt "$max_duration" ]; then
        local duration_min=$((duration / 60))
        notify-send "Error" "Video too long: ${duration_min} minutes\nMax length: 16 minutes"
        log_error "$search_query" "Duration too long: ${duration_min} minutes"
        return 1
    fi
    return 0
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

# Check for duplicates before downloading
if check_duplicate "$SEARCH_QUERY"; then
    log_error "$SEARCH_QUERY" "Duplicate: File already exists"
    exit 0
fi

# Check duration before downloading
if ! check_duration "$SEARCH_QUERY"; then
    exit 1
fi

# Start download with progress notification
notify-send "Starting Download" "Searching for: $SEARCH_QUERY"

# Temporary file for capturing yt-dlp output
TEMP_OUTPUT=$(mktemp)

# Attempt download using ytsearch with thumbnail embedding
if yt-dlp -x --audio-format mp3 \
    --output "$DOWNLOAD_DIR/%(title)s.%(ext)s" \
    --format bestaudio \
    --embed-thumbnail \
    --add-metadata \
    --parse-metadata "title:%(title)s" \
    --parse-metadata "artist:%(artist)s" \
    --match-filter "duration < 960" \
    "ytsearch1:$SEARCH_QUERY" 2>"$TEMP_OUTPUT"; then
    
    # Success
    notify-send "Download Complete" "Saved to media/music\n${SEARCH_QUERY}"
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
