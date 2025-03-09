#!/bin/bash

# Configuration
IMAGE_NAME="ghcr.io/sdiehl/docker-mlir-cuda"
TAG="main-arm64"
FULL_IMAGE_NAME="${IMAGE_NAME}:${TAG}"

# Ensure script fails on any error
set -e

echo "Logging in to GitHub Container Registry..."
# Make sure you're logged in to ghcr.io first
# You can login using: echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin
if ! docker login ghcr.io; then
    echo "Error: Failed to login to ghcr.io"
    exit 1
fi

echo "Building Docker image for ARM64..."
docker buildx create --use --name arm64_builder || true

docker buildx build \
  --platform linux/arm64 \
  --tag ${FULL_IMAGE_NAME} \
  --push \
  .

echo "Successfully built and pushed ${FULL_IMAGE_NAME} for ARM64"
