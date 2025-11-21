# Changelog - Whisper Transcriber

## [v2.0.0] - 2025-11-21 - Docker Release

### Added
- **Docker Support**: Full Docker containerization for easy deployment
  - `Dockerfile` with Python 3.11 and all dependencies
  - `docker-compose.yml` for one-command setup
  - Health checks and proper signal handling
  - Volume mounting for watch and transcript folders
  - Environment variable configuration

- **CI/CD Pipeline**: GitHub Actions automated builds
  - `.github/workflows/docker-build.yml` for automatic Docker image builds
  - Automatic tagging and registry push (ghcr.io)
  - Tests run on every pull request
  - Multi-platform build support

- **Docker Documentation**: Comprehensive guides
  - `DOCKER.md` - Complete Docker usage guide
  - GPU acceleration setup instructions
  - Kubernetes deployment examples
  - Docker Hub publishing guide

- **GitHub Sharing Guide**: `GITHUB_SETUP.md`
  - Step-by-step GitHub repository setup
  - Container Registry configuration
  - Sharing instructions for friends
  - Automated workflows explanation

- **Environment Variable Support**:
  - `WHISPER_MODEL` - Select model at runtime
  - `WATCH_DIR` - Configure watch directory
  - `OUTPUT_DIR` - Configure output directory
  - Full Docker compatibility

- **Improved Robustness**:
  - Optional `pyperclip` import (gracefully disabled in Docker)
  - Better error handling for missing dependencies
  - Support for both local and containerized environments

### Changed
- `transcriber.py`:
  - Made `pyperclip` optional for Docker environments
  - Added environment variable support for all paths and config
  - Improved clipboard monitor to handle missing pyperclip gracefully
  - Better logging for Docker environments

- `README.md`:
  - Updated to highlight Docker as primary method
  - Added quick Docker start guide
  - Links to comprehensive documentation

- `.gitignore`:
  - Added `data/` directory (user files)
  - Added docker-compose overrides
  - Preserved directory structure with `.gitkeep`

### Infrastructure
- Added `.dockerignore` for efficient builds
- GitHub Actions workflows for automated builds
- Docker image published to GitHub Container Registry
- Optional Docker Hub distribution

### Documentation
- Added `DOCKER.md` (comprehensive Docker guide)
- Added `GITHUB_SETUP.md` (sharing with friends)
- Updated `README.md` with Docker focus
- Added `CHANGELOG.md` (this file)

## [v1.0.0] - 2025-11-21 - Initial Release

### Features
- **Drag & Drop Videos**: Automatic transcription of dropped files
  - Monitors `~/Downloads/whisper_drop` folder
  - Supports MP4, AVI, MOV, MKV, FLV, WMV, M4A, MP3, WAV
  - Automatic file detection and processing

- **YouTube Integration**:
  - Clipboard monitoring for YouTube URLs
  - Automatic detection and transcription
  - Support for youtube.com, youtu.be, youtube-nocookie.com
  - yt-dlp for reliable downloads

- **Multiple Output Formats**:
  - Plain text (.txt)
  - JSON with metadata and confidence scores (.json)
  - WebVTT with timestamps (.vtt)
  - Timestamped filenames to prevent overwrites

- **Whisper Model Support**:
  - Configurable models: tiny, base, small, medium, large
  - Automatic model downloading and caching
  - Offline transcription

- **Cross-Platform Support**:
  - macOS native installation script
  - Drag-and-drop integration
  - Command-line interface
  - macOS app bundle creation

### Files
- `transcriber.py` - Main application logic
- `transcribe.sh` - Shell wrapper script
- `install-macos.sh` - macOS setup helper
- `test_transcriber.py` - Test suite (all tests passing)
- `QUICKSTART.md` - Quick start guide
- `README.md` - Full documentation
- `requirements.txt` - Python dependencies

### Testing
- Initialization tests
- Directory creation tests
- Timestamp formatting tests
- YouTube URL detection tests
- All tests passing ✓

---

## Upgrade Path: v1 → v2

### For Local Users
If you prefer local installation without Docker, v1 files remain functional.

### For Docker Users
```bash
# Pull latest version
docker pull ghcr.io/yourusername/whisper-transcriber:latest

# Or rebuild locally
git pull
docker-compose up -d
```

### For GitHub Sharers
v2 makes sharing much easier:
- No need to install Python dependencies locally
- Works on any machine with Docker
- Single command setup: `docker-compose up -d`
- Automatic CI/CD deployment

## Migration Notes

### Breaking Changes
None - v2 is fully backward compatible.

### New Features Available in v2
- Containerized deployment
- Automatic builds via GitHub Actions
- Easy GPU support
- Kubernetes-ready
- Better resource isolation

### Recommended Setup
- **Personal Use**: Either v1 (local) or v2 (Docker)
- **Sharing with Friends**: v2 (Docker) recommended
- **Production Deployment**: v2 (Docker) required

## Future Roadmap

### Planned for v2.x
- Web UI (Flask/FastAPI)
- REST API for transcription
- Batch processing support
- Advanced scheduling
- Cloud storage integration (S3, Google Drive)

### Planned for v3.0
- Real-time streaming support
- Multi-language support
- Speaker diarization
- Web dashboard
- Authentication and multi-user support

## Getting Help

- Issues: [GitHub Issues](https://github.com/yourusername/whisper-transcriber/issues)
- Discussions: [GitHub Discussions](https://github.com/yourusername/whisper-transcriber/discussions)
- Documentation:
  - Local: `QUICKSTART.md`
  - Docker: `DOCKER.md`
  - Sharing: `GITHUB_SETUP.md`

## Contributors

v1.0.0: Initial development
v2.0.0: Docker containerization and CI/CD
