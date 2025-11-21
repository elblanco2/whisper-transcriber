# GitHub Setup Guide - Share with Your Friends

This guide walks through publishing your Whisper Transcriber to GitHub and making Docker images available for easy sharing.

## Step 1: Create a GitHub Repository

### Option A: Use GitHub Web UI

1. Go to [github.com/new](https://github.com/new)
2. Fill in repository name: `whisper-transcriber`
3. Add description: "AI-powered video transcription with drag-and-drop and YouTube support"
4. Choose Public (so friends can access)
5. Click "Create Repository"

### Option B: Use Git CLI

```bash
# After creating repo on GitHub, in your local directory:
git remote add origin https://github.com/elblanco2/whisper-transcriber.git
git branch -M main
git push -u origin main
```

## Step 2: Push Your Code

```bash
cd /Users/luca/whisper

# Add all files
git add -A

# Commit with a clear message
git commit -m "Add Docker v2 with GitHub Actions CI/CD"

# Push to GitHub
git push origin main
```

## Step 3: Enable GitHub Container Registry

### Configure GitHub Package Settings

1. Go to your repository on GitHub
2. Click "Settings" → "Packages and registries"
3. Enable "GitHub Container Registry" if not already enabled

### Create Personal Access Token (PAT)

1. Go to [github.com/settings/tokens](https://github.com/settings/tokens)
2. Click "Generate new token" → "Generate new token (classic)"
3. Select scopes:
   - `write:packages`
   - `read:packages`
   - `delete:packages`
4. Copy the token and save it somewhere safe
5. In your repo: Settings → Secrets and variables → Actions
6. Add secret named `GITHUB_TOKEN` (it's usually auto-configured)

## Step 4: GitHub Actions Auto-Build

The `.github/workflows/docker-build.yml` will automatically:
- Build Docker image on every push to `main`
- Push to GitHub Container Registry
- Tag versions automatically

After your first push, check:
1. Go to "Actions" tab on GitHub
2. You should see a "Build and Push Docker Image" workflow running
3. Once complete, image available at: `ghcr.io/elblanco2/whisper-transcriber:latest`

## Step 5: Share with Friends

### Option 1: Direct Docker Pull

Your friends can now run:

```bash
# Pull the image
docker pull ghcr.io/elblanco2/whisper-transcriber:latest

# Or just clone and use docker-compose
git clone https://github.com/elblanco2/whisper-transcriber.git
cd whisper-transcriber
docker-compose up -d
```

### Option 2: Share Repository Link

Send friends your GitHub link:
```
https://github.com/elblanco2/whisper-transcriber
```

They can:
1. Clone it: `git clone https://github.com/elblanco2/whisper-transcriber.git`
2. Run it: `docker-compose up -d`

### Option 3: Docker Hub (Optional)

Push to Docker Hub for even wider distribution:

```bash
# Login to Docker Hub
docker login

# Tag image
docker tag ghcr.io/elblanco2/whisper-transcriber:latest elblanco2/whisper-transcriber:latest

# Push
docker push elblanco2/whisper-transcriber:latest
```

Friends can then use:
```bash
docker pull elblanco2/whisper-transcriber:latest
```

## Full Example: Your Friends' Setup

### Your Friend Receives Your Link

You send them:
```
https://github.com/elblanco2/whisper-transcriber
```

### Your Friend Sets Up (30 seconds)

```bash
# Clone
git clone https://github.com/elblanco2/whisper-transcriber.git
cd whisper-transcriber

# Create data folders
mkdir -p data/watch data/transcripts

# Start service
docker-compose up -d

# Done! Watch folder is at: ./data/watch/
```

### Your Friend Uses It

```bash
# Copy a video
cp ~/Downloads/my_video.mp4 ./data/watch/

# Wait a minute (model downloads on first run)
# Check results
ls ./data/transcripts/
```

## Monetization / Distribution

### Make It a Template

On GitHub:
1. Go to your repo Settings
2. Check "Template repository"
3. Now others can click "Use this template" to create their own copy

### Add a License

Add to your repo (MIT recommended):

```bash
curl -s https://api.github.com/licenses/mit | jq -r .body > LICENSE
git add LICENSE
git commit -m "Add MIT License"
git push
```

### Create Releases

When you want to version it:

```bash
git tag v2.0.0
git push origin v2.0.0
```

Then on GitHub, create release notes on the Releases page.

## Advanced: GitHub Pages Docs

Create a docs website (optional):

```bash
# Create docs directory
mkdir docs
echo "# Whisper Transcriber" > docs/index.md

# Commit
git add docs/
git commit -m "Add GitHub Pages docs"
git push

# Enable on GitHub: Settings → Pages → Source: main/docs
```

## Badges for README

Add these to your README for street cred:

```markdown
[![Docker Build](https://github.com/elblanco2/whisper-transcriber/actions/workflows/docker-build.yml/badge.svg)](https://github.com/elblanco2/whisper-transcriber/actions/workflows/docker-build.yml)
[![Latest Release](https://img.shields.io/github/v/release/elblanco2/whisper-transcriber)](https://github.com/elblanco2/whisper-transcriber/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Container Registry](https://img.shields.io/badge/Container-GHCR-blue)](https://github.com/users/elblanco2/packages/container/whisper-transcriber)
```

## Troubleshooting

### Docker image not building

1. Check Actions tab for build errors
2. Verify Dockerfile is in root directory
3. Check Docker Hub account has capacity (private repos limited)
4. Ensure GitHub token has proper permissions

### Friends can't pull image

```bash
# Check image exists
docker pull ghcr.io/elblanco2/whisper-transcriber:latest

# If private, need GitHub token:
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin
```

### Permission denied pushing

GitHub token might be expired. Generate new one in Settings.

## Next Steps

1. ✅ Push to GitHub
2. ✅ Enable GitHub Actions
3. ✅ Docker image auto-builds
4. ✅ Share with friends
5. 📝 Collect feedback
6. 🚀 Iterate and improve
7. 🎉 Show off to everyone!

## Share Your Success!

Once live, you can share:
- "Check out my new transcription tool!" - link to GitHub
- Create a short demo video
- Post on social media / forums
- Tell your friends they can run it with one command: `docker-compose up -d`

## Questions?

If friends have questions:
- Point them to [DOCKER.md](DOCKER.md) for Docker help
- Point them to [QUICKSTART.md](QUICKSTART.md) for usage
- They can open GitHub Issues with questions
- They can fork and contribute!

Good luck sharing! 🚀
