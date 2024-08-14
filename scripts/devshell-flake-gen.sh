#!/usr/bin/env bash

# Directory where templates are stored
TEMPLATE_DIR="/home/declan/Devel/dev-templates"

# Check if the argument is provided
if [ "$1" = "" ]; then
    echo "Usage: $0 --<env>"
    exit 1
fi

# Extract the environment variable from the argument
ENV=$(echo "$1" | sed 's/^--//')

# Check if the specified environment directory exists
if [ ! -d "$TEMPLATE_DIR/$ENV" ]; then
    echo "Invalid environment: $ENV"
    echo "Valid environments are:"
    for dir in "$TEMPLATE_DIR"/*; do
        if [ -d "$dir" ]; then
            option=$(basename "$dir")
            echo "  --$option"
        fi
    done
    exit 1
fi

# Run the nix flake init command
nix flake init --template github:declanriedel/dev-templates#$ENV

# Run the ndev command
