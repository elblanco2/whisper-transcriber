# 🎤 Whisper Transcriber - Your Friend's Quick Start

Your friend just sent you this. Here's how to get it running in **30 seconds**:

## TL;DR - Just Want It Working?

```bash
# 1. Clone
git clone https://github.com/yourusername/whisper-transcriber.git
cd whisper-transcriber

# 2. Create folders
mkdir -p data/watch data/transcripts

# 3. Start
docker-compose up -d

# 4. Done! Drop videos into data/watch/
```

That's it. Results show up in `data/transcripts/` in a few minutes.

## Okay, Tell Me More

### What is this?

It's an AI tool that transcribes videos to text. Drop a video in, get a transcript out.

### How does it work?

1. You drop a video file into `data/watch/`
2. The app automatically transcribes it
3. Results appear in `data/transcripts/` as text files

### What do I need?

- Docker (free, download from [docker.com](https://www.docker.com/products/docker-desktop))
- 10GB free disk space (for the AI model)
- A video file

### What formats work?

**Video**: MP4, AVI, MOV, MKV, FLV, WMV
**Audio**: M4A, MP3, WAV

## Usage Examples

### Example 1: Transcribe a Local Video

```bash
# 1. Copy a video file into the watch folder
cp ~/Downloads/my_video.mp4 ./data/watch/

# 2. Wait (takes ~1x the length of your video)
# First time takes longer (downloads AI model)

# 3. Check the results
ls ./data/transcripts/
cat ./data/transcripts/my_video_*.txt
```

### Example 2: Get Transcripts in Different Formats

For each video, you get 3 files:

- **my_video.txt** - Just the text
- **my_video.json** - Full data with timestamps
- **my_video.vtt** - Subtitles (for video editors)

Use whatever format you need!

### Example 3: Use YouTube Videos

```bash
# Copy a YouTube URL from your browser
# App asks: "Transcribe this video? (y/n):"
# Type: y
# Wait for download + transcription
```

*(Note: Clipboard monitoring might not work in Docker - see Troubleshooting)*

## Commands You'll Need

```bash
# Start the service
docker-compose up -d

# See what it's doing (live logs)
docker-compose logs -f

# Stop the service
docker-compose down

# Run with a different model (faster/slower)
WHISPER_MODEL=tiny docker-compose up -d
```

## Troubleshooting

### "Docker not found"
[Install Docker Desktop](https://www.docker.com/products/docker-desktop) for your OS.

### First run is taking forever
The AI model downloads (~140MB). Wait it out, future runs are faster.

### Results aren't showing up
1. Check logs: `docker-compose logs -f`
2. Wait longer (videos take time to process)
3. Make sure file is in the right folder: `./data/watch/`

### Permission issues with files
```bash
# Fix it with
chmod -R 755 ./data
```

### YouTube URLs not working
Clipboard monitoring requires system access that Docker doesn't have. Instead:
1. Use yt-dlp to download: `yt-dlp "https://..." -o "%(title)s.mp4"`
2. Drop the file in `data/watch/`
3. App will transcribe it

### Want faster transcription?
Use a smaller model:
```bash
# Stop current
docker-compose down

# Start with tiny model (faster, less accurate)
WHISPER_MODEL=tiny docker-compose up -d
```

### Want better transcription?
Use a larger model:
```bash
docker-compose down
WHISPER_MODEL=medium docker-compose up -d
```

## What You Get

After transcription, you have:

```
my_video_20251121_153045.txt
└─ Full transcript:
   "Hello, welcome to my video. This is the full text..."

my_video_20251121_153045.json
└─ Raw data with confidence scores and timing

my_video_20251121_153045.vtt
└─ Subtitles for video editors
   00:00:00.000 --> 00:00:05.000
   Hello, welcome to my video.
```

Use the `.txt` file for most things. The `.vtt` is great for video editing software.

## Tips & Tricks

**Tip 1**: Batch process - drop multiple videos, they queue automatically
**Tip 2**: The `.vtt` files work with most video editors for automatic subtitles
**Tip 3**: Check `data/transcripts/` often - files appear as soon as transcription finishes
**Tip 4**: Delete old `.json` files if you just want the text to save space

## Performance Expectations

- Tiny model: ~1x video length (fastest)
- Base model: ~3-5x video length (balanced - default)
- Medium model: ~10x video length (better accuracy)
- Large model: ~15x video length (best, very slow)

Example: 1-hour video on "base" model = ~4-5 hours processing time

## Next Steps

1. ✅ Install Docker
2. ✅ Clone the repo
3. ✅ Run `docker-compose up -d`
4. ✅ Drop a video in `data/watch/`
5. ✅ Wait for results
6. ✅ Find transcripts in `data/transcripts/`
7. 🎉 You're done!

## Got Questions?

- Check the full docs: `DOCKER.md`
- Found a bug? Create an issue on GitHub
- Want to help? Fork and contribute!

## One More Thing

Your friend made this for you. If you like it, give the GitHub repo a ⭐!

---

Happy transcribing! 🎬
