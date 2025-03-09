#!/bin/bash

# Exit on any error
set -e

# Check if environment variables are set
if [ -z "$GITHUB_TOKEN" ] || [ -z "$GITHUB_USER" ]; then
    echo "Error: GITHUB_TOKEN or GITHUB_USER environment variables are not set"
    echo "Please set them before running this script:"
    echo "export GITHUB_TOKEN=your_token"
    echo "export GITHUB_USER=your_username"
    exit 1
fi

# Login to GitHub Container Registry
echo "Logging into GitHub Container Registry..."
echo "$GITHUB_TOKEN" | docker login ghcr.io -u "$GITHUB_USER" --password-stdin

echo "Successfully logged into ghcr.io"
