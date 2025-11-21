#!/bin/bash

# Whisper Transcriber Shell Script
# Usage: ./transcribe.sh <video_file> or drag-drop videos

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_SCRIPT="$SCRIPT_DIR/transcriber.py"

# If no arguments, start the daemon
if [ $# -eq 0 ]; then
    echo "Starting Whisper Transcriber..."
    python3 "$PYTHON_SCRIPT"
else
    # Process provided files
    for video_file in "$@"; do
        if [ -f "$video_file" ]; then
            echo "Processing: $video_file"
            python3 -c "
import sys
sys.path.insert(0, '$SCRIPT_DIR')
from transcriber import VideoTranscriber
transcriber = VideoTranscriber()
transcriber.transcribe_file('$video_file')
"
        else
            echo "File not found: $video_file"
        fi
    done
fi
