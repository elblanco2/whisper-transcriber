#!/bin/bash

# Build and Push Script for Whisper Transcriber
# Publishes Docker image to GitHub Container Registry and Docker Hub
# Usage: ./build-and-push.sh

set -e

# Configuration
GITHUB_USERNAME="${GITHUB_USERNAME:-elblanco2}"
DOCKER_USERNAME="${DOCKER_USERNAME:-elblanco2}"
IMAGE_NAME="whisper-transcriber"
VERSION="${1:-latest}"

echo "🐳 Building and pushing Whisper Transcriber Docker image"
echo "=================================================="
echo "Image name: $IMAGE_NAME"
echo "Version: $VERSION"
echo ""

# Build image
echo "📦 Building Docker image..."
docker build -t $IMAGE_NAME:$VERSION .

# GitHub Container Registry
echo ""
echo "📤 Pushing to GitHub Container Registry..."
GHC_IMAGE="ghcr.io/$GITHUB_USERNAME/$IMAGE_NAME:$VERSION"
docker tag $IMAGE_NAME:$VERSION $GHC_IMAGE

docker login ghcr.io
docker push $GHC_IMAGE

echo "✓ Pushed to: $GHC_IMAGE"

# Docker Hub (optional)
echo ""
read -p "Push to Docker Hub too? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "📤 Pushing to Docker Hub..."
    DOCKER_IMAGE="$DOCKER_USERNAME/$IMAGE_NAME:$VERSION"
    docker tag $IMAGE_NAME:$VERSION $DOCKER_IMAGE

    docker login
    docker push $DOCKER_IMAGE

    echo "✓ Pushed to: $DOCKER_IMAGE"
fi

# Tag as latest
echo ""
echo "🏷️  Tagging as latest..."
docker tag $IMAGE_NAME:$VERSION $IMAGE_NAME:latest

echo ""
echo "✅ Done!"
echo ""
echo "Your friends can now pull with:"
echo "  docker pull ghcr.io/$GITHUB_USERNAME/$IMAGE_NAME:$VERSION"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "  docker pull $DOCKER_USERNAME/$IMAGE_NAME:$VERSION"
fi
echo ""
echo "Or clone and use:"
echo "  git clone https://github.com/$GITHUB_USERNAME/$IMAGE_NAME"
echo "  docker-compose up -d"
