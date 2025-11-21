# Project Structure - Whisper Transcriber

## Directory Layout

```
whisper/
├── 📄 Core Application Files
│   ├── transcriber.py          # Main app logic
│   ├── transcribe.sh           # Shell wrapper
│   ├── Dockerfile              # Docker image definition
│   ├── docker-compose.yml      # Docker orchestration
│   └── requirements.txt         # Python dependencies
│
├── 📁 GitHub / CI-CD
│   └── .github/workflows/
│       └── docker-build.yml    # GitHub Actions CI/CD
│
├── 📁 Data Directories
│   └── data/
│       ├── watch/             # Drop videos here
│       └── transcripts/        # Results saved here
│
├── 📚 Documentation
│   ├── README.md              # Main documentation
│   ├── QUICKSTART.md          # Quick start guide
│   ├── DOCKER.md              # Docker guide
│   ├── GITHUB_SETUP.md        # Publishing guide
│   ├── FRIEND_QUICK_START.md  # Share with friends
│   ├── CHANGELOG.md           # Version history
│   └── PROJECT_STRUCTURE.md   # This file
│
├── 🛠️ Utility Scripts
│   ├── install-macos.sh       # macOS setup (v1)
│   ├── build-and-push.sh      # Docker build & push
│   └── test_transcriber.py    # Test suite
│
└── 📋 Configuration
    ├── .gitignore             # Git ignore rules
    ├── .dockerignore          # Docker ignore rules
    └── .env (optional)        # Environment variables
```

## Version Information

### v1.0.0 (Local Installation)
- Direct Python execution
- Drag-and-drop file watching
- Clipboard YouTube integration
- macOS app bundle support
- **Files**: `transcriber.py`, `transcribe.sh`, `install-macos.sh`, `test_transcriber.py`
- **Documentation**: `QUICKSTART.md`, `README.md`
- **Backup**: `/Users/luca/whisper_v1/`

### v2.0.0 (Docker Release)
- Full Docker containerization
- GitHub Actions CI/CD
- Easy friend sharing
- Container registry publishing
- **Files**: All v1 files + Docker setup
- **Docker Files**: `Dockerfile`, `docker-compose.yml`, `build-and-push.sh`
- **Documentation**: `DOCKER.md`, `GITHUB_SETUP.md`, `FRIEND_QUICK_START.md`, `CHANGELOG.md`

## Quick Navigation

### For Local Development
- **Start here**: `README.md`
- **Quick setup**: `QUICKSTART.md`
- **Testing**: `test_transcriber.py`

### For Docker Users
- **Start here**: `README.md`
- **Docker guide**: `DOCKER.md`
- **Running**: `docker-compose.yml`

### For GitHub Sharing
- **Setup**: `GITHUB_SETUP.md`
- **Friend guide**: `FRIEND_QUICK_START.md`
- **Auto-builds**: `.github/workflows/docker-build.yml`

### For macOS
- **Setup (v1)**: `install-macos.sh`
- **Quick start**: `QUICKSTART.md`

## File Purposes

### Core Application
| File | Purpose | Language |
|------|---------|----------|
| `transcriber.py` | Main transcription logic | Python |
| `transcribe.sh` | Command-line wrapper | Bash |
| `test_transcriber.py` | Test suite | Python |

### Docker & Deployment
| File | Purpose | Format |
|------|---------|--------|
| `Dockerfile` | Container image definition | Docker |
| `docker-compose.yml` | Multi-container orchestration | YAML |
| `build-and-push.sh` | Build and publish script | Bash |
| `.github/workflows/docker-build.yml` | CI/CD automation | YAML |

### Configuration & Setup
| File | Purpose | Format |
|------|---------|--------|
| `requirements.txt` | Python dependencies | txt |
| `.gitignore` | Git ignore rules | txt |
| `.dockerignore` | Docker ignore rules | txt |
| `install-macos.sh` | macOS installer | Bash |

### Documentation
| File | Audience | Length |
|------|----------|--------|
| `README.md` | Everyone | Comprehensive |
| `QUICKSTART.md` | Local users | Concise |
| `DOCKER.md` | Docker users | Detailed |
| `GITHUB_SETUP.md` | Publisher | Step-by-step |
| `FRIEND_QUICK_START.md` | End users | Very quick |
| `CHANGELOG.md` | Developers | Complete history |
| `PROJECT_STRUCTURE.md` | Developers | This file |

## Dependencies

### System Level
- Docker (v2)
- ffmpeg (audio processing)
- Python 3.8+ (v1) or 3.11 (Docker)

### Python Packages
See `requirements.txt` for full list:
- `openai-whisper` - Speech recognition
- `yt-dlp` - YouTube downloads
- `pyperclip` - Clipboard monitoring
- `watchdog` - File system watching
- `torch` - Deep learning (from Whisper)
- `numpy`, `tiktoken` - Supporting libraries

## Data Flow

```
User Action
    ↓
┌───────────────────────────────────┐
│   Video File Dropped              │
│   or YouTube URL Copied           │
└──────────────┬────────────────────┘
               ↓
┌───────────────────────────────────┐
│   Watchdog / Clipboard Monitor    │
│   Detects New File/URL            │
└──────────────┬────────────────────┘
               ↓
┌───────────────────────────────────┐
│   Download (if YouTube)           │
│   Extract Audio                   │
└──────────────┬────────────────────┘
               ↓
┌───────────────────────────────────┐
│   Whisper Model Transcription     │
│   (tiny/base/small/medium/large)  │
└──────────────┬────────────────────┘
               ↓
┌───────────────────────────────────┐
│   Save Results                    │
│   .txt | .json | .vtt             │
└──────────────┬────────────────────┘
               ↓
         User Has Transcript!
```

## Configuration Options

### Environment Variables
```bash
WHISPER_MODEL    # Model to use (tiny, base, small, medium, large)
WATCH_DIR        # Directory to monitor for videos
OUTPUT_DIR       # Directory to save transcripts
PYTHONUNBUFFERED # Show logs in real-time (Docker)
```

### Code Configuration
In `transcriber.py`:
```python
MODEL_NAME = "base"
WATCH_DIR = "~/Downloads/whisper_drop"
OUTPUT_DIR = "~/whisper_transcripts"
SUPPORTED_VIDEO_FORMATS = {...}
```

## Deployment Modes

### Mode 1: Local Installation (v1)
```
your_machine
    ↓
python transcriber.py
    ↓
Runs directly, uses system Python
```

### Mode 2: Docker Locally (v2)
```
your_machine
    ↓
docker-compose up
    ↓
Containerized, isolated environment
```

### Mode 3: Docker Hub/GHCR (v2)
```
your_machine
    ↓
docker run ghcr.io/user/whisper-transcriber
    ↓
Pre-built image, no build needed
```

### Mode 4: GitHub Actions Auto-Deploy (v2)
```
git push
    ↓
GitHub Actions triggers
    ↓
Builds Docker image
    ↓
Pushes to GHCR
    ↓
Friends can pull immediately
```

## Development Workflow

### Making Changes
1. Edit source files
2. Test locally: `python test_transcriber.py`
3. Test in Docker: `docker-compose up`
4. Commit: `git add -A && git commit -m "..."`
5. Push: `git push origin main`
6. GitHub Actions automatically builds Docker image

### Building Docker Image
```bash
# Build locally
docker build -t whisper-transcriber:latest .

# Or use helper script
./build-and-push.sh
```

### Publishing
- **Automatic**: Push to main → GitHub Actions builds & pushes to GHCR
- **Manual**: `./build-and-push.sh` for Docker Hub too

## Backup & Versions

### Current Structure
```
/Users/luca/whisper       ← v2 (current, Docker)
/Users/luca/whisper_v1    ← v1 backup (local)
```

### Retrieving v1
If needed, use v1 from backup:
```bash
cp -r /Users/luca/whisper_v1 ./local-version
cd local-version
pip install -r requirements.txt
./transcribe.sh
```

## Size Estimates

### Repository
- Source code: ~100KB
- All documentation: ~150KB
- Git history: ~50KB
- **Total**: ~300KB (very lightweight)

### Models (downloaded at runtime)
- Tiny: 39MB
- Base: 140MB
- Small: 461MB
- Medium: 1.5GB
- Large: 2.9GB

### Docker Image
- Base image: ~200MB
- Dependencies: ~2GB
- **Total**: ~2.2GB (without models)
- Models download into container at runtime

## Performance Characteristics

| Model | Speed | Accuracy | Size | GPU Benefit |
|-------|-------|----------|------|-------------|
| tiny | 1x | Low | 39MB | Low |
| base | 3-5x | Medium | 140MB | Medium |
| small | 5-10x | Good | 461MB | High |
| medium | 10x | Better | 1.5GB | Very High |
| large | 15x | Best | 2.9GB | Very High |

*Speed = relative to video length*

## Security Considerations

### v1 (Local)
- Requires system Python access
- Uses system clipboard
- Direct file system access
- YouTube downloads via yt-dlp

### v2 (Docker)
- Isolated container environment
- No system clipboard access
- Managed volume mounts
- YouTube downloads within container
- Can restrict resource access

### Best Practices
- Run on trusted machines
- Keep Whisper model updated
- Monitor disk space usage
- Regular backups of transcripts

## Testing

### Test Suite
```bash
python test_transcriber.py
```

Tests:
- Initialization
- Directory creation
- Timestamp formatting
- YouTube URL detection

### All tests passing ✓

## Troubleshooting Guide

### Quick Reference
| Issue | Solution | Doc |
|-------|----------|-----|
| Docker not found | Install Docker Desktop | DOCKER.md |
| Slow first run | Model downloads (~2-5 min) | DOCKER.md |
| Permission denied | `chmod +x` scripts | README.md |
| Out of memory | Increase Docker memory | DOCKER.md |
| YouTube URL ignored | Clipboard not available in Docker | DOCKER.md |

See full docs for detailed troubleshooting.

## Future Extensions

### Possible Additions (v3+)
- Web UI (Flask/FastAPI)
- REST API
- Batch processing
- Real-time streaming
- Speaker diarization
- Multi-language support
- Cloud storage integration
- Authentication & multi-user

## Contact & Support

- **Bug Reports**: GitHub Issues
- **Questions**: GitHub Discussions
- **Pull Requests**: Welcome!
- **License**: [Add license info]

---

**Last Updated**: 2025-11-21
**Current Version**: v2.0.0
**Status**: Production Ready ✓
