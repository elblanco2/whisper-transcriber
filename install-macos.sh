#!/bin/bash

# macOS Installation Script for Whisper Transcriber
# This script sets up the application for easy access

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing Whisper Transcriber for macOS..."
echo "============================================"

# Create necessary directories
echo "Creating directories..."
mkdir -p ~/Downloads/whisper_drop
mkdir -p ~/whisper_transcripts

# Make scripts executable
chmod +x "$SCRIPT_DIR/transcribe.sh"
chmod +x "$SCRIPT_DIR/transcriber.py"

# Option 1: Create symlink in /usr/local/bin for easy command-line access
echo "Setting up command-line access..."
ln -sf "$SCRIPT_DIR/transcribe.sh" /usr/local/bin/transcribe 2>/dev/null || {
    echo "Note: Couldn't create /usr/local/bin symlink (requires sudo)"
    echo "You can use the script directly: $SCRIPT_DIR/transcribe.sh"
}

# Option 2: Create a macOS Application Bundle (optional)
APP_DIR="$HOME/Applications/WhisperTranscriber.app"
mkdir -p "$APP_DIR/Contents/MacOS"
mkdir -p "$APP_DIR/Contents/Resources"

cat > "$APP_DIR/Contents/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>WhisperTranscriber</string>
    <key>CFBundleIdentifier</key>
    <string>com.local.whispergui</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>Whisper Transcriber</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
</dict>
</plist>
EOF

cat > "$APP_DIR/Contents/MacOS/WhisperTranscriber" << EOF
#!/bin/bash
exec python3 "$SCRIPT_DIR/transcriber.py"
EOF

chmod +x "$APP_DIR/Contents/MacOS/WhisperTranscriber"

echo "✓ Installation complete!"
echo ""
echo "Usage options:"
echo "1. Command line: transcribe /path/to/video.mp4"
echo "2. Run as daemon: transcribe"
echo "3. Drop files into: ~/Downloads/whisper_drop"
echo "4. macOS App: Double-click ~/Applications/WhisperTranscriber.app"
echo ""
echo "Transcript files will be saved to: ~/whisper_transcripts"
