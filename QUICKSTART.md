# Quick Start Guide - Whisper Transcriber

## 1-Minute Setup

```bash
cd ~/whisper

# Install dependencies (first time only)
pip install -r requirements.txt

# Make sure ffmpeg is installed
brew install ffmpeg

# Create watch directories (first time only)
mkdir -p ~/Downloads/whisper_drop
mkdir -p ~/whisper_transcripts
```

## Usage

### Start the Transcriber Service

```bash
./transcribe.sh
```

You'll see:
```
🎤 Whisper Transcriber Started
Model: base
Watch folder: /Users/luca/Downloads/whisper_drop
Output folder: /Users/luca/whisper_transcripts
Watching folder: /Users/luca/Downloads/whisper_drop
Clipboard monitoring enabled

Ready! You can:
  1. Drop video files into: /Users/luca/Downloads/whisper_drop
  2. Copy a YouTube URL and paste it here (or press Ctrl+V)
  3. Press Ctrl+C to quit
```

### Option 1: Drag & Drop Files

1. Open Finder and navigate to `~/Downloads/whisper_drop`
2. Drag a video file into this folder
3. The transcriber automatically starts processing
4. Results save to `~/whisper_transcripts`

### Option 2: Transcribe YouTube Videos

1. Copy a YouTube URL (Cmd+C): `https://www.youtube.com/watch?v=...`
2. The transcriber detects it and asks: "Transcribe this video? (y/n):"
3. Type `y` to start transcription
4. Results save to `~/whisper_transcripts`

### Option 3: Direct Command Line

Transcribe a single file:

```bash
./transcribe.sh /path/to/video.mp4
```

## Example Workflow

### Transcribe a Local Video

```
1. Download a video to ~/Downloads/whisper_drop/
2. Wait for automatic transcription (1-5 minutes depending on video length)
3. Check ~/whisper_transcripts/ for results
   - my_video_20251121_153045.txt (transcript)
   - my_video_20251121_153045.json (full metadata)
   - my_video_20251121_153045.vtt (timed transcript)
```

### Transcribe a YouTube Video

```
1. Open YouTube.com
2. Copy video URL (Cmd+C)
3. See prompt in terminal: "📋 YouTube URL detected in clipboard!"
4. Type 'y' to confirm
5. App downloads audio and transcribes (5-15 minutes)
6. Results in ~/whisper_transcripts/
```

## Output Files Explained

For each transcription, you get three files:

**1. .txt file** - Plain text transcript
```
Hello, this is a test video. This is the transcript of everything said.
```

**2. .json file** - Full metadata with per-segment info
```json
{
  "text": "Hello, this is a test video...",
  "segments": [
    {
      "id": 0,
      "seek": 0,
      "start": 0.0,
      "end": 2.5,
      "text": "Hello, this is a test video.",
      "confidence": 0.95
    }
  ]
}
```

**3. .vtt file** - Subtitles with timestamps (great for video editors)
```
WEBVTT

00:00:00.000 --> 00:00:02.500
Hello, this is a test video.

00:00:02.500 --> 00:00:05.000
This is the transcript of everything said.
```

## Keyboard Shortcuts

- **Cmd+C** - Copy (for YouTube URLs)
- **Ctrl+C** - Quit the transcriber
- **Cmd+V** - Paste URL when prompted for YouTube transcription

## Troubleshooting

### "Model is downloading..." takes forever
- The first run downloads the Whisper model (~140MB for "base")
- This only happens once
- Subsequent runs are much faster

### "ffmpeg not found"
```bash
brew install ffmpeg
```

### YouTube URL not detected
- Make sure the URL is in your clipboard before the app checks
- Try copying again and wait a moment for detection
- Supported formats:
  - https://www.youtube.com/watch?v=...
  - https://youtu.be/...
  - https://youtube-nocookie.com/...

### Transcription is slow
- Check: longer videos take longer (roughly 1x video length)
- Use "tiny" model for faster transcription (less accurate)
- Edit `transcriber.py` and change `MODEL_NAME = "tiny"`

### Permission denied
```bash
chmod +x transcribe.sh
```

## Advanced Configuration

Edit `transcriber.py` to change:

```python
# Model: tiny (39MB), base (140MB), small (461MB), medium (1.5GB), large (2.9GB)
MODEL_NAME = "base"

# Where to watch for dropped files
WATCH_DIR = os.path.expanduser("~/Downloads/whisper_drop")

# Where to save transcripts
OUTPUT_DIR = os.path.expanduser("~/whisper_transcripts")

# Add more video formats (in SUPPORTED_VIDEO_FORMATS)
```

## Performance Tips

1. **Faster transcription**: Use `MODEL_NAME = "tiny"` (less accurate, ~1-2 minutes)
2. **Better accuracy**: Use `MODEL_NAME = "small"` or `"medium"` (slower, ~5-15 minutes)
3. **GPU acceleration**: Automatically enabled on:
   - NVIDIA GPUs (with CUDA)
   - Apple Silicon Macs (Metal Performance Shaders)

## Next Steps

- Use the `.vtt` files in video editors for automatic subtitles
- Export `.txt` for documentation or transcription services
- Use `.json` for programmatic access to confidence scores
- Integrate with other tools (Obsidian, Notion, etc.)

Happy transcribing! 🎬
