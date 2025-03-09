#!/bin/bash

# Configuration
IMAGE_NAME="ghcr.io/sdiehl/docker-mlir-cuda"
TAG="main"
FULL_IMAGE_NAME="${IMAGE_NAME}:${TAG}"

# Ensure script fails on any error
set -e

echo "Building Docker image..."
docker build -t ${FULL_IMAGE_NAME} .

echo "Logging in to GitHub Container Registry..."
# Make sure you're logged in to ghcr.io first
# You can login using: echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin
if ! docker login ghcr.io; then
    echo "Error: Failed to login to ghcr.io"
    exit 1
fi

echo "Pushing image to GitHub Container Registry..."
docker push ${FULL_IMAGE_NAME}

echo "Successfully built and pushed ${FULL_IMAGE_NAME}"
