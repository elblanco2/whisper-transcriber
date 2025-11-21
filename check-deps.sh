#!/bin/bash

# Whisper Transcriber - Dependency Checker
# Verifies all required dependencies are installed
# Works for both local and Docker setups

set +e  # Don't exit on errors

PASSED=0
FAILED=0
WARNINGS=0

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║      Whisper Transcriber - Dependency Checker                ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if running in Docker
if [ -f /.dockerenv ]; then
    echo -e "${GREEN}✓${NC} Running inside Docker container"
    echo ""
    echo "Docker dependencies are pre-configured. Checking Python packages..."
    echo ""
    DOCKER_MODE=true
else
    echo -e "${YELLOW}ℹ${NC} Running locally (not in Docker)"
    echo ""
    DOCKER_MODE=false
fi

echo -e "${BLUE}System Dependencies:${NC}"
echo "──────────────────────────────────────────────────────────────"

# Check Python
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
    echo -e "${GREEN}✓${NC} Python 3 found: $PYTHON_VERSION"
    ((PASSED++))
else
    echo -e "${RED}✗${NC} Python 3 not found"
    echo "  Install: brew install python3 (macOS) or apt-get install python3 (Linux)"
    ((FAILED++))
fi

# Check pip
if command -v pip3 &> /dev/null; then
    echo -e "${GREEN}✓${NC} pip3 found"
    ((PASSED++))
else
    echo -e "${RED}✗${NC} pip3 not found"
    echo "  Install: python3 -m ensurepip --upgrade"
    ((FAILED++))
fi

# Check ffmpeg
if command -v ffmpeg &> /dev/null; then
    FFMPEG_VERSION=$(ffmpeg -version 2>&1 | head -n1)
    echo -e "${GREEN}✓${NC} ffmpeg found: $FFMPEG_VERSION"
    ((PASSED++))
else
    if [ "$DOCKER_MODE" = false ]; then
        echo -e "${RED}✗${NC} ffmpeg not found (required for video/audio processing)"
        echo "  Install: brew install ffmpeg (macOS)"
        echo "           apt-get install ffmpeg (Linux)"
        ((FAILED++))
    else
        echo -e "${GREEN}✓${NC} ffmpeg (pre-installed in Docker)"
        ((PASSED++))
    fi
fi

# Check Docker (only if not in Docker)
if [ "$DOCKER_MODE" = false ]; then
    echo ""
    echo -e "${BLUE}Docker (if using Docker deployment):${NC}"
    echo "──────────────────────────────────────────────────────────────"

    if command -v docker &> /dev/null; then
        DOCKER_VERSION=$(docker --version)
        echo -e "${GREEN}✓${NC} Docker found: $DOCKER_VERSION"
        ((PASSED++))
    else
        echo -e "${YELLOW}⚠${NC} Docker not found (optional, only needed for Docker deployment)"
        echo "  Install: https://www.docker.com/products/docker-desktop"
        ((WARNINGS++))
    fi

    if command -v docker-compose &> /dev/null; then
        COMPOSE_VERSION=$(docker-compose --version)
        echo -e "${GREEN}✓${NC} docker-compose found: $COMPOSE_VERSION"
        ((PASSED++))
    else
        echo -e "${YELLOW}⚠${NC} docker-compose not found (optional, only needed for Docker deployment)"
        ((WARNINGS++))
    fi
fi

echo ""
echo -e "${BLUE}Python Packages:${NC}"
echo "──────────────────────────────────────────────────────────────"

# Array of required packages
REQUIRED_PACKAGES=(
    "whisper:openai-whisper"
    "yt_dlp:yt-dlp"
    "watchdog:watchdog"
    "torch:torch"
)

OPTIONAL_PACKAGES=(
    "pyperclip:pyperclip (clipboard monitoring)"
)

for package_entry in "${REQUIRED_PACKAGES[@]}"; do
    IFS=':' read -r import_name package_name <<< "$package_entry"

    if python3 -c "import $import_name" 2>/dev/null; then
        VERSION=$(python3 -c "import ${import_name}; print(getattr(${import_name}, '__version__', 'unknown'))" 2>/dev/null || echo "")
        if [ -z "$VERSION" ] || [ "$VERSION" = "unknown" ]; then
            echo -e "${GREEN}✓${NC} $package_name installed"
        else
            echo -e "${GREEN}✓${NC} $package_name installed ($VERSION)"
        fi
        ((PASSED++))
    else
        echo -e "${RED}✗${NC} $package_name not found (REQUIRED)"
        echo "  Install: pip3 install -r requirements.txt"
        ((FAILED++))
    fi
done

echo ""
echo -e "${BLUE}Optional Packages:${NC}"
echo "──────────────────────────────────────────────────────────────"

for package_entry in "${OPTIONAL_PACKAGES[@]}"; do
    IFS=':' read -r import_name package_desc <<< "$package_entry"

    if python3 -c "import $import_name" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} $package_desc"
        ((PASSED++))
    else
        echo -e "${YELLOW}⚠${NC} $package_desc not found (optional)"
        echo "  Install: pip3 install $import_name"
        ((WARNINGS++))
    fi
done

echo ""
echo -e "${BLUE}Directory Permissions:${NC}"
echo "──────────────────────────────────────────────────────────────"

if [ "$DOCKER_MODE" = false ]; then
    # Check if data directories exist and are writable
    mkdir -p data/watch data/transcripts 2>/dev/null

    if [ -w "./data/watch" ]; then
        echo -e "${GREEN}✓${NC} data/watch is writable"
        ((PASSED++))
    else
        echo -e "${RED}✗${NC} data/watch is not writable"
        echo "  Fix: chmod 755 data/watch"
        ((FAILED++))
    fi

    if [ -w "./data/transcripts" ]; then
        echo -e "${GREEN}✓${NC} data/transcripts is writable"
        ((PASSED++))
    else
        echo -e "${RED}✗${NC} data/transcripts is not writable"
        echo "  Fix: chmod 755 data/transcripts"
        ((FAILED++))
    fi
else
    echo -e "${GREEN}✓${NC} Docker volumes (pre-configured)"
    ((PASSED++))
fi

# Summary
echo ""
echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                       SUMMARY                                 ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${GREEN}✓ Passed${NC}:   $PASSED"
echo -e "  ${RED}✗ Failed${NC}:   $FAILED"
echo -e "  ${YELLOW}⚠ Warnings${NC}: $WARNINGS"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ All required dependencies are satisfied!${NC}"
    echo ""
    if [ "$DOCKER_MODE" = false ]; then
        echo "You can now run:"
        echo "  ./transcribe.sh          # Start the service"
        echo "  ./transcribe.sh <file>   # Transcribe a specific file"
    else
        echo "Whisper Transcriber is ready to use!"
        echo "Drop videos into /data/watch/"
    fi
    EXIT_CODE=0
else
    echo -e "${RED}❌ Some required dependencies are missing!${NC}"
    echo ""
    echo "Please install the missing dependencies shown above."
    echo ""
    echo "Quick install (local):"
    echo "  pip3 install -r requirements.txt"
    echo "  brew install ffmpeg  # macOS"
    echo ""
    EXIT_CODE=1
fi

if [ $WARNINGS -gt 0 ] && [ $FAILED -eq 0 ]; then
    echo -e "${YELLOW}Note: Some optional features may not be available.${NC}"
    echo "Install optional packages above for full functionality."
fi

echo ""
exit $EXIT_CODE
