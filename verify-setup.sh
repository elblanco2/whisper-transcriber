#!/bin/bash

# Whisper Transcriber - Setup Verification
# Complete check for both local and Docker deployments

set +e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║      Whisper Transcriber - Setup Verification                ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""

PASS=0
WARN=0
FAIL=0

# Check deployment mode
echo -e "${BLUE}Deployment Mode:${NC}"
echo "──────────────────────────────────────────────────────────────"

if command -v docker &> /dev/null && [ -f "docker-compose.yml" ]; then
    echo -e "${GREEN}✓${NC} Docker available and docker-compose.yml found"
    echo ""
    echo "Recommended: Use Docker for easiest deployment!"
    echo "  docker-compose up -d"
    echo ""
    ((PASS++))
else
    echo -e "${YELLOW}ℹ${NC} Docker not found or docker-compose.yml missing"
    echo "  Will verify local setup instead"
    ((WARN++))
fi

echo ""
echo -e "${BLUE}Project Structure:${NC}"
echo "──────────────────────────────────────────────────────────────"

REQUIRED_FILES=(
    "transcriber.py"
    "transcribe.sh"
    "requirements.txt"
    "docker-compose.yml"
    "Dockerfile"
    "README.md"
    "DOCKER.md"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $file"
        ((PASS++))
    else
        echo -e "${RED}✗${NC} $file MISSING"
        ((FAIL++))
    fi
done

echo ""
echo -e "${BLUE}Data Directories:${NC}"
echo "──────────────────────────────────────────────────────────────"

mkdir -p data/watch data/transcripts

if [ -w "data/watch" ] && [ -w "data/transcripts" ]; then
    echo -e "${GREEN}✓${NC} data/watch directory ready"
    echo -e "${GREEN}✓${NC} data/transcripts directory ready"
    ((PASS += 2))
else
    echo -e "${RED}✗${NC} Data directories not writable"
    echo "  Fix: chmod 755 data/"
    ((FAIL++))
fi

echo ""
echo -e "${BLUE}Configuration Files:${NC}"
echo "──────────────────────────────────────────────────────────────"

if [ -f ".gitignore" ]; then
    echo -e "${GREEN}✓${NC} .gitignore configured"
    ((PASS++))
else
    echo -e "${YELLOW}⚠${NC} .gitignore missing"
    ((WARN++))
fi

if [ -f ".dockerignore" ]; then
    echo -e "${GREEN}✓${NC} .dockerignore configured"
    ((PASS++))
else
    echo -e "${YELLOW}⚠${NC} .dockerignore missing"
    ((WARN++))
fi

if [ -d ".github/workflows" ]; then
    echo -e "${GREEN}✓${NC} GitHub Actions configured"
    ((PASS++))
else
    echo -e "${YELLOW}⚠${NC} GitHub Actions not found"
    ((WARN++))
fi

echo ""
echo -e "${BLUE}Documentation:${NC}"
echo "──────────────────────────────────────────────────────────────"

DOC_FILES=(
    "README.md:Main documentation"
    "DOCKER.md:Docker guide"
    "QUICKSTART.md:Quick start guide"
    "FRIEND_QUICK_START.md:Friend guide"
    "GITHUB_SETUP.md:GitHub setup"
)

for doc_entry in "${DOC_FILES[@]}"; do
    IFS=':' read -r file desc <<< "$doc_entry"
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $file ($desc)"
        ((PASS++))
    else
        echo -e "${YELLOW}⚠${NC} $file missing"
        ((WARN++))
    fi
done

echo ""
echo -e "${BLUE}Scripts:${NC}"
echo "──────────────────────────────────────────────────────────────"

SCRIPTS=(
    "transcribe.sh"
    "install-macos.sh"
    "check-deps.sh"
    "start.sh"
    "build-and-push.sh"
)

for script in "${SCRIPTS[@]}"; do
    if [ -f "$script" ]; then
        if [ -x "$script" ]; then
            echo -e "${GREEN}✓${NC} $script (executable)"
        else
            echo -e "${YELLOW}⚠${NC} $script (not executable)"
            chmod +x "$script" 2>/dev/null
            echo "     Fixed: made executable"
        fi
        ((PASS++))
    else
        echo -e "${YELLOW}⚠${NC} $script missing"
        ((WARN++))
    fi
done

echo ""
echo -e "${BLUE}Environment:${NC}"
echo "──────────────────────────────────────────────────────────────"

if [ -f ".env" ]; then
    echo -e "${GREEN}✓${NC} .env file found"
    ((PASS++))
else
    echo -e "${YELLOW}ℹ${NC} No .env file (using defaults)"
    ((WARN++))
fi

echo ""
echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                      SUMMARY                                  ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${GREEN}✓ Passed${NC}:   $PASS"
echo -e "  ${YELLOW}⚠ Warnings${NC}: $WARN"
echo -e "  ${RED}✗ Failed${NC}:   $FAIL"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}✅ Setup is valid!${NC}"
    echo ""
    echo "Next steps:"
    echo ""
    echo "  Docker deployment (recommended):"
    echo "    mkdir -p data/watch data/transcripts"
    echo "    docker-compose up -d"
    echo ""
    echo "  Local deployment:"
    echo "    bash check-deps.sh"
    echo "    bash start.sh"
    echo ""
    echo "  Or use the wrapper:"
    echo "    bash transcribe.sh"
    echo ""
    exit 0
else
    echo -e "${RED}❌ Setup has issues!${NC}"
    echo ""
    echo "Please fix the errors above and try again."
    echo ""
    exit 1
fi
