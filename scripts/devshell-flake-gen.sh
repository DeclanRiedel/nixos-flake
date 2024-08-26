#!/usr/bin/env bash

# Check if the argument is provided
if [ "$1" = "" ]; then
    echo "Usage: $0 <env>"
    exit 1
fi

# Use the environment variable directly from the argument
ENV="$1"

# Create a temporary directory
TEMP_DIR=$(mktemp -d)
echo "Created temporary directory: $TEMP_DIR"

# Change to the temporary directory
cd "$TEMP_DIR" || exit 1

# Download the flake files
if ! nix flake init --template github:declanriedel/dev-templates#$ENV; then
    echo "Error: Failed to initialize flake for environment $ENV"
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo "Flake files downloaded successfully."

# Run nix develop in the temporary directory
if ! nix develop; then
    echo "Error: Failed to run nix develop for environment $ENV"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Clean up temporary directory (this will run after nix develop exits)
rm -rf "$TEMP_DIR"

zsh
