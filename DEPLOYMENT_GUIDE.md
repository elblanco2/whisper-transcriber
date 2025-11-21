# Deployment Guide - Whisper Transcriber

Complete guide for deploying Whisper Transcriber with automatic dependency checking and feedback.

## Before You Start

Two deployment options:
1. **Docker** (Recommended) - All dependencies included, works anywhere
2. **Local** (Python) - Requires manual dependency installation

## Quick Deploy (Choose One)

### Option 1: Docker Deployment (Easiest)

```bash
# 1. Verify your setup
bash verify-setup.sh

# 2. Create data directories
mkdir -p data/watch data/transcripts

# 3. Start the service
docker-compose up -d
```

That's it! Docker handles all dependencies automatically.

### Option 2: Local Deployment (Python)

```bash
# 1. Check dependencies
bash check-deps.sh

# 2. If there are failures, install missing packages:
pip3 install -r requirements.txt
brew install ffmpeg  # macOS

# 3. Start the service
bash start.sh
# or
./transcribe.sh
```

## Dependency Verification Tools

### 1. `verify-setup.sh` - Complete Setup Verification

Checks your entire installation before deployment:

```bash
bash verify-setup.sh
```

**Output:** Shows if all files, directories, and configurations are correct.

**What it checks:**
- ✓ Deployment mode (Docker vs Local)
- ✓ Project structure (all files present)
- ✓ Data directories (writable)
- ✓ Configuration files (.gitignore, .dockerignore, GitHub Actions)
- ✓ Documentation files
- ✓ Scripts (all executable)
- ✓ Environment configuration

**Exit codes:**
- `0` - Setup is valid, ready to deploy
- `1` - Setup has issues, fix them first

### 2. `check-deps.sh` - Dependency Checker

Verifies all required dependencies are installed:

```bash
bash check-deps.sh
```

**Output:** Detailed report of each dependency.

**What it checks (Local mode):**
- ✓ Python 3
- ✓ pip3
- ✓ ffmpeg
- ✓ Docker (optional)
- ✓ docker-compose (optional)
- ✓ All Python packages (whisper, yt-dlp, watchdog, torch, etc.)
- ✓ Optional packages (pyperclip)
- ✓ Directory permissions

**What it checks (Docker mode):**
- ✓ Python packages inside container
- ✓ System dependencies (pre-installed in Docker)

**Exit codes:**
- `0` - All required dependencies present, ready to use
- `1` - Some required dependencies missing, install them first

**Helpful feedback:**
If a dependency is missing, the script tells you how to install it:

```
✗ ffmpeg not found (required for video/audio processing)
  Install: brew install ffmpeg (macOS)
           apt-get install ffmpeg (Linux)
```

### 3. `start.sh` - Smart Startup Script

Intelligent startup that checks dependencies before running:

```bash
bash start.sh
```

**Features:**
- Detects if running in Docker or locally
- Automatically runs `check-deps.sh` for local deployments
- Provides helpful error messages if dependencies are missing
- Creates required directories
- Starts the transcription service

**What it does:**

**In Docker:**
```
🐳 Running in Docker container
✓ Starting transcription service...
```

**Locally:**
```
💻 Running locally (non-Docker)
Checking dependencies...
✓ All dependencies satisfied!
✓ Starting transcription service...
```

## Deployment Workflows

### Workflow 1: Deploying with Docker (Recommended)

```bash
# Step 1: Verify setup
bash verify-setup.sh

# Expected output:
# ✅ Setup is valid!
#
# Next steps:
#   Docker deployment (recommended):
#     mkdir -p data/watch data/transcripts
#     docker-compose up -d

# Step 2: Create directories
mkdir -p data/watch data/transcripts

# Step 3: Start
docker-compose up -d

# Step 4: Monitor
docker-compose logs -f

# Step 5: Deploy to production
docker tag whisper-transcriber:latest yourusername/whisper-transcriber:v1.0
docker push yourusername/whisper-transcriber:v1.0
```

### Workflow 2: Deploying Locally

```bash
# Step 1: Check dependencies
bash check-deps.sh

# Expected output:
# ✅ All required dependencies are satisfied!

# Step 2: If errors, install dependencies
pip3 install -r requirements.txt
brew install ffmpeg  # macOS only

# Step 3: Re-check dependencies
bash check-deps.sh

# Step 4: Start
bash start.sh

# Or manually:
python3 transcriber.py
```

### Workflow 3: Sharing with Friends (GitHub)

```bash
# Step 1: Verify your setup
bash verify-setup.sh

# Step 2: Push to GitHub
git add -A
git commit -m "Add dependency checking and deployment tools"
git push origin main

# Step 3: Send friends your link
# https://github.com/elblanco2/whisper-transcriber

# Step 4: They verify their setup
# bash verify-setup.sh

# Step 5: They deploy
# docker-compose up -d
```

## Dependency Reference

### Docker Mode

All dependencies are pre-installed in the Docker image. No setup needed!

```dockerfile
FROM python:3.11-slim

# System dependencies (automatic)
RUN apt-get install ffmpeg

# Python packages (from requirements.txt)
- openai-whisper
- yt-dlp
- pyperclip
- watchdog
- torch
- numpy
- tiktoken
```

### Local Mode

#### Required Dependencies

**System Level:**
- Python 3.8+ (3.12+ recommended)
- pip3
- ffmpeg (for audio/video processing)

**Install:**
```bash
# macOS
brew install python3 ffmpeg

# Linux (Ubuntu/Debian)
sudo apt-get install python3 python3-pip ffmpeg

# Or from source
python3 -m pip install --upgrade pip
```

**Python Packages:**
- openai-whisper >= 20250625
- yt-dlp >= 2025.11.12
- watchdog >= 6.0.0
- torch >= 2.9.1
- numpy >= 2.3.5
- tiktoken >= 0.12.0

**Install:**
```bash
pip3 install -r requirements.txt
```

#### Optional Dependencies

- pyperclip - For clipboard monitoring (recommended)
  - Install: `pip3 install pyperclip`
  - Without it: YouTube feature disabled, but everything else works

## Troubleshooting

### Setup Verification Fails

```bash
# Run:
bash verify-setup.sh

# Check the output for what's missing
# Common issues:
# - Missing data/ directories: mkdir -p data/watch data/transcripts
# - Not executable scripts: chmod +x *.sh
# - Wrong Docker version: Install Docker Desktop
```

### Dependency Check Fails

```bash
# Run:
bash check-deps.sh

# Install missing packages shown in output
# Example:
pip3 install openai-whisper
brew install ffmpeg
```

### Docker Build Fails

```bash
# Check Docker installation
docker --version
docker-compose --version

# Clear Docker cache and rebuild
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

### Permission Denied

```bash
# Make scripts executable
chmod +x *.sh

# Fix directory permissions
chmod 755 data/watch data/transcripts
```

### Package Import Errors

```bash
# Reinstall all packages
pip3 install --upgrade -r requirements.txt

# Or fresh install
pip3 uninstall -y -r requirements.txt
pip3 install -r requirements.txt
```

## Health Checks

### Docker Health Check

Docker automatically monitors container health:

```bash
# Check status
docker-compose ps

# Expected output:
# STATUS: Up X minutes (healthy)

# If unhealthy, check logs
docker-compose logs
```

### Manual Health Check

```bash
# Test Whisper import
python3 -c "import whisper; print('✓ Whisper ready')"

# Test yt-dlp
python3 -c "import yt_dlp; print('✓ yt-dlp ready')"

# Test watchdog
python3 -c "import watchdog; print('✓ watchdog ready')"
```

## Automated Checks in CI/CD

The GitHub Actions workflow automatically:

```yaml
# Runs on every push
- Checks out code
- Builds Docker image
- Runs Python tests
- Pushes to GitHub Container Registry
```

No manual checks needed - it's all automated!

## Best Practices

1. **Always run setup verification first:**
   ```bash
   bash verify-setup.sh
   ```

2. **Check dependencies before deployment:**
   ```bash
   bash check-deps.sh
   ```

3. **Use Docker for production:**
   ```bash
   docker-compose up -d
   ```

4. **Monitor logs during first run:**
   ```bash
   docker-compose logs -f
   ```

5. **Keep dependencies updated:**
   ```bash
   pip3 install --upgrade -r requirements.txt
   ```

## For Your Friends

When sharing with friends, send them:

1. **Your GitHub link:**
   ```
   https://github.com/elblanco2/whisper-transcriber
   ```

2. **Deployment instructions:**
   ```bash
   git clone https://github.com/elblanco2/whisper-transcriber.git
   cd whisper-transcriber
   bash verify-setup.sh    # They verify setup
   docker-compose up -d    # They deploy
   ```

3. **What they'll see:**
   ```
   ✅ Setup is valid!

   Next steps:
     Docker deployment (recommended):
       mkdir -p data/watch data/transcripts
       docker-compose up -d
   ```

Everything is automated and provides helpful feedback at each step!

## Support

If deployment fails:

1. Run: `bash verify-setup.sh`
2. Run: `bash check-deps.sh`
3. Check the output for what's missing
4. Follow the installation instructions provided
5. Re-run the checks

All error messages include exact installation commands!

---

**Status:** All dependency checks implemented ✓
**Last Updated:** 2025-11-21
