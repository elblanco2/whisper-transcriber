# Whisper Transcriber v2

A powerful drag-and-drop video transcription tool powered by OpenAI's Whisper. Transcribe videos, YouTube links, and audio files to text with ease. **Now with Docker support for easy sharing and deployment!**

## Features

- **Drag & Drop Support**: Drop video files into a folder and they're automatically transcribed
- **YouTube Integration**: Copy a YouTube link and transcribe it automatically
- **Multiple Output Formats**:
  - Plain text (.txt)
  - JSON with metadata (.json)
  - WebVTT with timestamps (.vtt)
- **Clipboard Monitoring**: Automatically detects YouTube URLs in your clipboard
- **Support for Multiple Formats**: MP4, AVI, MOV, MKV, FLV, WMV, M4A, MP3, WAV
- **Docker Support**: Run anywhere with one command
- **GPU Acceleration**: Optional NVIDIA GPU support for faster transcription

## Quick Start (Docker - Recommended)

```bash
# Clone repo and navigate to it
git clone https://github.com/elblanco2/whisper-transcriber.git
cd whisper-transcriber

# Create data directories
mkdir -p data/watch data/transcripts

# Start the service
docker-compose up -d

# Drop videos into data/watch/ folder
cp /path/to/video.mp4 ./data/watch/

# Check results in data/transcripts/
ls ./data/transcripts/
```

For more Docker details, see [DOCKER.md](DOCKER.md).

## Installation

### Prerequisites
- Python 3.8+
- ffmpeg (required for audio extraction)

### macOS Installation

```bash
# Install ffmpeg if you don't have it
brew install ffmpeg

# Clone or navigate to the whisper directory
cd ~/whisper

# Run the installation script
chmod +x install-macos.sh
./install-macos.sh

# Install Python dependencies
pip install -r requirements.txt
```

### Manual Setup

```bash
# Create the watch folder
mkdir -p ~/Downloads/whisper_drop

# Create the output folder
mkdir -p ~/whisper_transcripts

# Install dependencies
pip install -r requirements.txt
```

## Usage

### Option 1: Run as a Daemon (Recommended)

Start the service in the background:

```bash
./transcribe.sh
```

Or with the command-line shortcut (after installation):

```bash
transcribe
```

This will:
1. Watch `~/Downloads/whisper_drop` for new video files
2. Monitor your clipboard for YouTube URLs
3. Automatically transcribe any videos you drop into the folder
4. Ask for confirmation before transcribing YouTube videos from your clipboard

### Option 2: Transcribe Individual Files

```bash
./transcribe.sh /path/to/video.mp4
```

Or:

```bash
transcribe /path/to/video.mp4
```

### Option 3: macOS Application

After installation, you can launch the app from Applications folder or run:

```bash
open ~/Applications/WhisperTranscriber.app
```

## Workflow Examples

### Example 1: Transcribe a Local Video
1. Copy a video file to `~/Downloads/whisper_drop`
2. The app automatically transcribes it
3. Results are saved to `~/whisper_transcripts`

### Example 2: Transcribe a YouTube Video
1. Copy a YouTube URL to your clipboard (Cmd+C)
2. The app detects it and asks for confirmation
3. Downloads the audio and transcribes it
4. Results are saved to `~/whisper_transcripts`

## Output Files

For each transcribed video, three files are created:

- `video_name_YYYYMMDD_HHMMSS.txt` - Plain text transcript
- `video_name_YYYYMMDD_HHMMSS.json` - Full JSON with metadata and per-segment text
- `video_name_YYYYMMDD_HHMMSS.vtt` - WebVTT format with timestamps

## Configuration

Edit `transcriber.py` to modify:

```python
MODEL_NAME = "base"  # Options: tiny, base, small, medium, large
WATCH_DIR = os.path.expanduser("~/Downloads/whisper_drop")
OUTPUT_DIR = os.path.expanduser("~/whisper_transcripts")
```

- **tiny**: Fastest, least accurate (~39MB)
- **base**: Good balance (~140MB) - Default
- **small**: Better accuracy (~461MB)
- **medium**: High accuracy (~1.5GB)
- **large**: Highest accuracy (~2.9GB)

## Troubleshooting

### "ffmpeg not found" error
Install ffmpeg:
```bash
brew install ffmpeg
```

### YouTube downloads fail
Update yt-dlp:
```bash
pip install --upgrade yt-dlp
```

### Permission denied on shell script
Make it executable:
```bash
chmod +x transcribe.sh
```

### Application won't start on macOS
Check that you've installed all dependencies:
```bash
pip install -r requirements.txt
```

## Project Structure

```
whisper/
├── transcriber.py          # Main transcription logic
├── transcribe.sh           # Shell wrapper script
├── install-macos.sh        # macOS installation helper
├── requirements.txt        # Python dependencies
└── README.md              # This file
```

## Supported Formats

**Video**: MP4, AVI, MOV, MKV, FLV, WMV
**Audio**: M4A, MP3, WAV

## Performance Tips

- Use the **tiny** or **base** model for quick transcriptions
- Use **small** or **medium** for better accuracy
- GPU acceleration is enabled automatically if you have CUDA support
- On Apple Silicon Macs, the model will use Metal Performance Shaders

## Tips

- Keep the app running in a terminal window while you work
- The watch folder will continuously monitor for new files
- Transcriptions are timestamped to avoid overwriting
- JSON output includes confidence scores and per-segment information

## License

This tool uses OpenAI's Whisper model. See [OpenAI's documentation](https://github.com/openai/whisper) for details.

## Building on This

The modular design makes it easy to extend:
- Add to a web interface using Flask/FastAPI
- Integrate with a GUI using PyQt or Tkinter
- Send transcripts to cloud storage (S3, Google Drive, etc.)
- Add support for other transcription APIs
- Create browser extension for direct YouTube transcription
