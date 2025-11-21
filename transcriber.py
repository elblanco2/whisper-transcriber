#!/usr/bin/env python3
"""
Whisper Transcriber - Drag & Drop and YouTube support
Transcribes videos and YouTube content using OpenAI's Whisper
"""

import os
import sys
import json
import subprocess
import threading
import time
from pathlib import Path
from datetime import datetime
import whisper
import yt_dlp
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
from tqdm import tqdm

# Try to import pyperclip, but make it optional for Docker environments
try:
    import pyperclip
    PYPERCLIP_AVAILABLE = True
except ImportError:
    PYPERCLIP_AVAILABLE = False

# Configuration - supports environment variable overrides for Docker
WATCH_DIR = os.getenv("WATCH_DIR", os.path.expanduser("~/Downloads/whisper_drop"))
OUTPUT_DIR = os.getenv("OUTPUT_DIR", os.path.expanduser("~/whisper_transcripts"))
MODEL_NAME = os.getenv("WHISPER_MODEL", "base")  # Options: tiny, base, small, medium, large
SUPPORTED_VIDEO_FORMATS = {".mp4", ".avi", ".mov", ".mkv", ".flv", ".wmv", ".m4a", ".mp3", ".wav"}


class VideoTranscriber:
    def __init__(self):
        self.model = None
        self.last_clipboard = ""
        self._load_model()
        os.makedirs(OUTPUT_DIR, exist_ok=True)
        os.makedirs(WATCH_DIR, exist_ok=True)

    def _load_model(self):
        """Load Whisper model"""
        if self.model is None:
            print(f"Loading Whisper model: {MODEL_NAME}")
            self.model = whisper.load_model(MODEL_NAME)

    def _get_output_path(self, filename: str) -> str:
        """Generate output file path for transcript"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        base_name = Path(filename).stem
        return os.path.join(OUTPUT_DIR, f"{base_name}_{timestamp}")

    def transcribe_file(self, video_path: str) -> str:
        """Transcribe a video file"""
        if not os.path.exists(video_path):
            return f"Error: File not found: {video_path}"

        print(f"\n{'='*60}")
        print(f"Transcribing: {Path(video_path).name}")
        print(f"{'='*60}")

        try:
            output_prefix = self._get_output_path(video_path)

            # Transcribe
            result = self.model.transcribe(video_path, verbose=True)

            # Save transcript as JSON
            json_path = f"{output_prefix}.json"
            with open(json_path, "w") as f:
                json.dump(result, f, indent=2)

            # Save transcript as TXT
            txt_path = f"{output_prefix}.txt"
            with open(txt_path, "w") as f:
                f.write(result["text"])

            # Save transcript with timestamps as VTT
            vtt_path = f"{output_prefix}.vtt"
            with open(vtt_path, "w") as f:
                f.write("WEBVTT\n\n")
                for segment in result["segments"]:
                    start = self._format_timestamp(segment["start"])
                    end = self._format_timestamp(segment["end"])
                    f.write(f"{start} --> {end}\n{segment['text'].strip()}\n\n")

            message = f"✓ Transcription complete!\nFiles saved:\n  • {txt_path}\n  • {json_path}\n  • {vtt_path}"
            print(message)
            return message

        except Exception as e:
            error_msg = f"✗ Error transcribing {Path(video_path).name}: {str(e)}"
            print(error_msg)
            return error_msg

    def download_youtube_transcript(self, url: str) -> str:
        """Download and transcribe a YouTube video"""
        print(f"\n{'='*60}")
        print(f"Processing YouTube video: {url}")
        print(f"{'='*60}")

        try:
            # Extract video info
            with yt_dlp.YoutubeDL({"quiet": True}) as ydl:
                info = ydl.extract_info(url, download=False)
                video_title = info.get("title", "youtube_video")
                video_id = info.get("id", "unknown")

            # Download audio
            temp_dir = os.path.join(OUTPUT_DIR, ".temp")
            os.makedirs(temp_dir, exist_ok=True)

            audio_path = os.path.join(temp_dir, f"{video_id}.m4a")

            print(f"Downloading audio: {video_title}")
            ydl_opts = {
                "format": "bestaudio/best",
                "postprocessors": [{
                    "key": "FFmpegExtractAudio",
                    "preferredcodec": "m4a",
                    "preferredquality": "192",
                }],
                "outtmpl": os.path.join(temp_dir, video_id),
                "quiet": False,
                "no_warnings": True,
            }

            with yt_dlp.YoutubeDL(ydl_opts) as ydl:
                ydl.download([url])

            # Transcribe
            print(f"Transcribing audio...")
            result = self.model.transcribe(audio_path, verbose=False)

            # Save results
            output_prefix = os.path.join(OUTPUT_DIR, f"{video_title}_{datetime.now().strftime('%Y%m%d_%H%M%S')}")

            json_path = f"{output_prefix}.json"
            with open(json_path, "w") as f:
                json.dump(result, f, indent=2)

            txt_path = f"{output_prefix}.txt"
            with open(txt_path, "w") as f:
                f.write(result["text"])

            vtt_path = f"{output_prefix}.vtt"
            with open(vtt_path, "w") as f:
                f.write("WEBVTT\n\n")
                for segment in result["segments"]:
                    start = self._format_timestamp(segment["start"])
                    end = self._format_timestamp(segment["end"])
                    f.write(f"{start} --> {end}\n{segment['text'].strip()}\n\n")

            # Cleanup temp file
            if os.path.exists(audio_path):
                os.remove(audio_path)

            message = f"✓ YouTube transcript complete!\nTitle: {video_title}\nFiles saved:\n  • {txt_path}\n  • {json_path}\n  • {vtt_path}"
            print(message)
            return message

        except Exception as e:
            error_msg = f"✗ Error processing YouTube video: {str(e)}"
            print(error_msg)
            return error_msg

    @staticmethod
    def _format_timestamp(seconds: float) -> str:
        """Format seconds to VTT timestamp format"""
        hours = int(seconds // 3600)
        minutes = int((seconds % 3600) // 60)
        secs = int(seconds % 60)
        millis = int(round((seconds % 1) * 1000))
        return f"{hours:02d}:{minutes:02d}:{secs:02d}.{millis:03d}"


class DropFolderWatcher(FileSystemEventHandler):
    """Watch folder for dropped video files"""

    def __init__(self, transcriber: VideoTranscriber):
        self.transcriber = transcriber

    def on_created(self, event):
        if not event.is_directory:
            file_path = event.src_path
            file_ext = Path(file_path).suffix.lower()

            # Check if it's a supported format
            if file_ext in SUPPORTED_VIDEO_FORMATS:
                # Wait for file to be fully copied
                time.sleep(2)
                self.transcriber.transcribe_file(file_path)


class ClipboardMonitor:
    """Monitor clipboard for YouTube URLs"""

    def __init__(self, transcriber: VideoTranscriber):
        self.transcriber = transcriber
        self.last_clipboard = ""

    def start(self):
        """Start monitoring clipboard in background"""
        thread = threading.Thread(target=self._monitor_loop, daemon=True)
        thread.start()

    def _monitor_loop(self):
        """Monitor clipboard for changes"""
        if not PYPERCLIP_AVAILABLE:
            print("⚠️  Pyperclip not available - clipboard monitoring disabled")
            return

        while True:
            try:
                current_clipboard = pyperclip.paste()

                if current_clipboard != self.last_clipboard:
                    self.last_clipboard = current_clipboard

                    # Check if it's a YouTube URL
                    if self._is_youtube_url(current_clipboard):
                        print(f"\n📋 YouTube URL detected in clipboard!")
                        response = input("Transcribe this video? (y/n): ").lower().strip()
                        if response == 'y':
                            self.transcriber.download_youtube_transcript(current_clipboard)

                time.sleep(1)
            except Exception as e:
                print(f"Clipboard monitor error: {e}")
                time.sleep(5)

    @staticmethod
    def _is_youtube_url(text: str) -> bool:
        """Check if text is a YouTube URL"""
        youtube_domains = ["youtube.com", "youtu.be", "youtube-nocookie.com"]
        return any(domain in text for domain in youtube_domains)


def main():
    print("🎤 Whisper Transcriber Started")
    print(f"Model: {MODEL_NAME}")
    print(f"Watch folder: {WATCH_DIR}")
    print(f"Output folder: {OUTPUT_DIR}")
    print("-" * 60)

    # Initialize transcriber
    transcriber = VideoTranscriber()

    # Start watching drop folder
    print(f"Watching folder: {WATCH_DIR}")
    observer = Observer()
    observer.schedule(DropFolderWatcher(transcriber), WATCH_DIR, recursive=False)
    observer.start()

    # Start clipboard monitor
    print("Clipboard monitoring enabled")
    clipboard_monitor = ClipboardMonitor(transcriber)
    clipboard_monitor.start()

    print("\nReady! You can:")
    print(f"  1. Drop video files into: {WATCH_DIR}")
    print("  2. Copy a YouTube URL and paste it here (or press Ctrl+V)")
    print("  3. Press Ctrl+C to quit\n")

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("\n\nShutting down...")
        observer.stop()
        observer.join()
        print("Bye!")


if __name__ == "__main__":
    main()
