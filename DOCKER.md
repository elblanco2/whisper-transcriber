# Docker Setup - Whisper Transcriber v2

Running Whisper Transcriber in Docker makes it easy to deploy, share, and run on any machine without worrying about dependencies.

## Quick Start with Docker

### Prerequisites

- Docker installed ([Get Docker](https://docs.docker.com/get-docker/))
- Docker Compose (comes with Docker Desktop)
- 10GB free disk space (for Whisper models)

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/whisper-transcriber.git
cd whisper-transcriber
```

### 2. Create Data Directories

```bash
mkdir -p data/watch data/transcripts
```

### 3. Start the Container

```bash
docker-compose up -d
```

The service will:
- Start in the background
- Create volumes for watch folder and output
- Download the Whisper model on first run (~140MB for "base")
- Watch `/data/watch` for new video files

### 4. Use It

Drop videos into the `data/watch` folder:

```bash
cp /path/to/video.mp4 ./data/watch/
```

Results appear in `data/transcripts/`:

```bash
ls ./data/transcripts/
# video_20251121_153045.txt
# video_20251121_153045.json
# video_20251121_153045.vtt
```

## Commands

### View Logs

```bash
docker-compose logs -f
```

### Stop the Service

```bash
docker-compose down
```

### Restart the Service

```bash
docker-compose restart
```

### Run with Different Model

```bash
WHISPER_MODEL=small docker-compose up -d
```

### Access Container Shell

```bash
docker-compose exec whisper-transcriber bash
```

## Configuration

Edit environment variables in `docker-compose.yml` or set them on the command line:

```bash
# Use small model (better accuracy, slower)
WHISPER_MODEL=small docker-compose up -d

# Use tiny model (faster, less accurate)
WHISPER_MODEL=tiny docker-compose up -d
```

Available models:
- `tiny` - Fastest (~39MB)
- `base` - Balanced (default, ~140MB)
- `small` - Better (~461MB)
- `medium` - High accuracy (~1.5GB)
- `large` - Highest (~2.9GB)

## Docker Hub / GitHub Container Registry

### Pull Pre-built Image

Instead of building locally, you can pull the pre-built image:

```bash
# From GitHub Container Registry (recommended)
docker pull ghcr.io/yourusername/whisper-transcriber:latest

# Or from Docker Hub
docker pull yourusername/whisper-transcriber:latest
```

Then run it:

```bash
docker run -it \
  -v $(pwd)/data/watch:/data/watch \
  -v $(pwd)/data/transcripts:/data/transcripts \
  ghcr.io/yourusername/whisper-transcriber:latest
```

## Building Your Own Image

Build the Docker image locally:

```bash
docker build -t whisper-transcriber:latest .
```

Tag it for Docker Hub or GitHub Container Registry:

```bash
# GitHub Container Registry
docker tag whisper-transcriber:latest ghcr.io/yourusername/whisper-transcriber:latest
docker push ghcr.io/yourusername/whisper-transcriber:latest

# Docker Hub
docker tag whisper-transcriber:latest yourusername/whisper-transcriber:latest
docker push yourusername/whisper-transcriber:latest
```

## GPU Support (NVIDIA)

If you have an NVIDIA GPU, enable GPU acceleration:

### 1. Install NVIDIA Docker Runtime

```bash
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update && sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker
```

### 2. Update docker-compose.yml

Uncomment the GPU section:

```yaml
runtime: nvidia
environment:
  NVIDIA_VISIBLE_DEVICES: all
```

### 3. Run with GPU

```bash
docker-compose up -d
```

Whisper will automatically detect and use the GPU.

## Advanced: Kubernetes Deployment

For production deployment on Kubernetes:

```bash
# Create namespace
kubectl create namespace whisper

# Create PersistentVolumes
kubectl apply -f k8s-pv.yaml -n whisper

# Deploy
kubectl apply -f k8s-deployment.yaml -n whisper

# Check logs
kubectl logs -f deployment/whisper-transcriber -n whisper
```

## Troubleshooting

### Container won't start

Check logs:
```bash
docker-compose logs whisper-transcriber
```

### Permission denied on volumes

Fix permissions:
```bash
sudo chown -R $(id -u):$(id -g) ./data
chmod -R 755 ./data
```

### Model download is slow

Models are downloaded on first run. Be patient or use a smaller model:

```bash
WHISPER_MODEL=tiny docker-compose up -d
```

### Out of memory

Docker containers have memory limits. Increase in docker-compose.yml:

```yaml
services:
  whisper-transcriber:
    mem_limit: 4g
    memswap_limit: 4g
```

### GPU not detected

Verify NVIDIA Docker:
```bash
docker run --rm --runtime=nvidia nvidia/cuda:12.0-runtime-ubuntu22.04 nvidia-smi
```

## Volume Mounts

The Docker setup uses volume mounts to share files:

```
./data/watch       ←→  /data/watch (inside container)
./data/transcripts ←→  /data/transcripts (inside container)
```

Files in `./data/watch` are automatically transcribed and results appear in `./data/transcripts`.

## Networking

The container doesn't expose any ports by default. If you want to build a web interface later, you can expose ports:

```yaml
ports:
  - "8080:8080"
```

## Environment Variables

Full list of supported variables in the container:

```
WHISPER_MODEL     - Model to use (tiny, base, small, medium, large)
WATCH_DIR         - Directory to watch for videos (default: /data/watch)
OUTPUT_DIR        - Directory for transcripts (default: /data/transcripts)
PYTHONUNBUFFERED  - Set to 1 to see logs in real-time
```

## Performance Tips

1. **Use solid-state storage** - Faster I/O improves throughput
2. **Allocate sufficient memory** - At least 4GB recommended
3. **Use GPU** - Dramatically speeds up transcription (5-10x faster)
4. **Choose appropriate model** - `tiny` for speed, `large` for accuracy
5. **Run on dedicated hardware** - Don't share machine with heavy workloads

## Sharing with Your Friends

### Option 1: GitHub with Actions (Recommended)

1. Push to GitHub
2. GitHub Actions automatically builds Docker image
3. Share the GitHub repo link
4. Friends can use: `docker pull ghcr.io/yourusername/whisper-transcriber:latest`

### Option 2: Docker Hub

1. Push to Docker Hub
2. Friends can use: `docker pull yourusername/whisper-transcriber`

### Option 3: Share docker-compose.yml

Simply share the `docker-compose.yml` file - friends can:

```bash
docker-compose up -d
```

## Next Steps

- Set up GitHub Actions for automatic builds (see `.github/workflows/docker-build.yml`)
- Add web UI using Flask/FastAPI
- Create Kubernetes manifests for cloud deployment
- Add CI/CD pipeline for testing

## Support

For issues:
1. Check logs: `docker-compose logs`
2. Verify volumes are mounted correctly
3. Ensure Docker has enough resources
4. Check Docker Hub/GHCR for available images

Happy transcribing in Docker! 🐳
