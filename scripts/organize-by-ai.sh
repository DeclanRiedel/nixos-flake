#!/usr/bin/env bash

# Check if directory argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <music_directory>"
    exit 1
fi

MUSIC_DIR="$1"
LOG_FILE="$MUSIC_DIR/ai_organization_errors.txt"
CACHE_FILE="$MUSIC_DIR/.artist_cache.txt"

# Function to query OpenAI API
get_artist_from_ai() {
    local title="$1"
    local response
    
    # Replace with your OpenAI API key
    local API_KEY="your_openai_api_key"
    
    response=$(curl -s https://api.openai.com/v1/chat/completions \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $API_KEY" \
        -d '{
            "model": "gpt-3.5-turbo",
            "messages": [
                {
                    "role": "system",
                    "content": "You are a music expert. Return only the artist name for the given song title. If unsure, return UNKNOWN."
                },
                {
                    "role": "user",
                    "content": "'"$title"'"
                }
            ],
            "temperature": 0.3,
            "max_tokens": 50
        }' | jq -r '.choices[0].message.content')
    
    echo "$response"
}

# Create cache file if it doesn't exist
touch "$CACHE_FILE"
echo "Starting AI-based organization at $(date)" > "$LOG_FILE"

# Process each MP3 file
find "$MUSIC_DIR" -maxdepth 1 -type f -name "*.mp3" | while read -r file; do
    filename=$(basename "$file")
    title="${filename%.*}"
    
    # Check cache first
    cached_artist=$(grep "^$title|" "$CACHE_FILE" | cut -d'|' -f2)
    
    if [ -z "$cached_artist" ]; then
        # Query AI for artist
        artist=$(get_artist_from_ai "$title")
        echo "$title|$artist" >> "$CACHE_FILE"
    else
        artist="$cached_artist"
    fi
    
    # If AI couldn't determine artist
    if [ -z "$artist" ] || [ "$artist" = "UNKNOWN" ]; then
        artist="Unknown Artist"
        echo "Could not determine artist for: $file" >> "$LOG_FILE"
    fi
    
    # Clean artist name for directory
    artist_dir=$(echo "$artist" | tr -d '/<>:"|?*\\')
    target_dir="$MUSIC_DIR/$artist_dir"
    
    # Create artist directory if it doesn't exist
    mkdir -p "$target_dir"
    
    # Move file to artist directory
    mv "$file" "$target_dir/"
    echo "Moved: $file -> $target_dir/"
done

echo "AI-based organization complete. Check $LOG_FILE for any errors." 