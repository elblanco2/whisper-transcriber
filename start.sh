#!/bin/bash

# Whisper Transcriber - Smart Startup Script
# Checks dependencies and provides helpful feedback

set -e

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║         Whisper Transcriber - Starting...                    ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Detect if Docker is being used
if [ -f /.dockerenv ]; then
    echo "🐳 Running in Docker container"
    echo ""
    echo "✓ Starting transcription service..."
    echo ""
    exec python3 /app/transcriber.py
else
    echo "💻 Running locally (non-Docker)"
    echo ""

    # Check dependencies
    echo "Checking dependencies..."
    if ! bash ./check-deps.sh; then
        echo ""
        echo "❌ Dependency check failed!"
        echo ""
        echo "Please install missing dependencies and try again."
        exit 1
    fi

    echo ""
    echo "✓ All dependencies satisfied!"
    echo ""
    echo "Starting transcription service..."
    echo ""

    # Create data directories
    mkdir -p ~/Downloads/whisper_drop ~/whisper_transcripts

    # Run transcriber
    exec python3 transcriber.py
fi
