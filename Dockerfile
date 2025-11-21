FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    ffmpeg \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY transcriber.py .
COPY transcribe.sh .

# Make scripts executable
RUN chmod +x /app/transcriber.py /app/transcribe.sh

# Create volumes for watch folder and output
RUN mkdir -p /data/watch /data/transcripts

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV WATCH_DIR=/data/watch
ENV OUTPUT_DIR=/data/transcripts

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python3 -c "import whisper; print('healthy')" || exit 1

# Run the transcriber
CMD ["python3", "/app/transcriber.py"]
