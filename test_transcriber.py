#!/usr/bin/env python3
"""
Test script for Whisper Transcriber
Tests basic functionality without requiring actual video files
"""

import os
import sys
from pathlib import Path

# Add current directory to path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from transcriber import VideoTranscriber, ClipboardMonitor

def test_initialization():
    """Test that the transcriber initializes correctly"""
    print("Testing initialization...")
    try:
        transcriber = VideoTranscriber()
        print("✓ Transcriber initialized successfully")
        print(f"  - Model loaded: {transcriber.model is not None}")
        print(f"  - Output directory: {os.path.expanduser('~/whisper_transcripts')}")
        print(f"  - Watch directory: {os.path.expanduser('~/Downloads/whisper_drop')}")
        return True
    except Exception as e:
        print(f"✗ Failed to initialize transcriber: {e}")
        return False

def test_directories():
    """Test that required directories exist"""
    print("\nTesting directories...")
    watch_dir = os.path.expanduser("~/Downloads/whisper_drop")
    output_dir = os.path.expanduser("~/whisper_transcripts")

    try:
        os.makedirs(watch_dir, exist_ok=True)
        os.makedirs(output_dir, exist_ok=True)
        print(f"✓ Watch directory ready: {watch_dir}")
        print(f"✓ Output directory ready: {output_dir}")
        return True
    except Exception as e:
        print(f"✗ Failed to create directories: {e}")
        return False

def test_timestamp_formatting():
    """Test VTT timestamp formatting"""
    print("\nTesting timestamp formatting...")
    try:
        transcriber = VideoTranscriber()

        test_cases = [
            (0, "00:00:00.000"),
            (3661.5, "01:01:01.500"),
            (7322.999, "02:02:02.999"),
        ]

        for seconds, expected in test_cases:
            result = transcriber._format_timestamp(seconds)
            if result == expected:
                print(f"✓ {seconds}s -> {result}")
            else:
                print(f"✗ {seconds}s -> {result} (expected {expected})")
                return False
        return True
    except Exception as e:
        print(f"✗ Timestamp test failed: {e}")
        return False

def test_youtube_detection():
    """Test YouTube URL detection"""
    print("\nTesting YouTube URL detection...")
    monitor = ClipboardMonitor(None)

    test_cases = [
        ("https://www.youtube.com/watch?v=dQw4w9WgXcQ", True),
        ("https://youtu.be/dQw4w9WgXcQ", True),
        ("https://www.youtube-nocookie.com/embed/dQw4w9WgXcQ", True),
        ("https://github.com/openai/whisper", False),
        ("Just some random text", False),
    ]

    all_passed = True
    for url, expected in test_cases:
        result = monitor._is_youtube_url(url)
        status = "✓" if result == expected else "✗"
        print(f"{status} '{url[:50]}...' -> {result}")
        if result != expected:
            all_passed = False

    return all_passed

def main():
    print("=" * 60)
    print("Whisper Transcriber - Test Suite")
    print("=" * 60)

    results = {
        "Initialization": test_initialization(),
        "Directories": test_directories(),
        "Timestamp Formatting": test_timestamp_formatting(),
        "YouTube Detection": test_youtube_detection(),
    }

    print("\n" + "=" * 60)
    print("Test Results")
    print("=" * 60)

    for test_name, passed in results.items():
        status = "✓ PASS" if passed else "✗ FAIL"
        print(f"{status}: {test_name}")

    all_passed = all(results.values())

    print("\n" + "=" * 60)
    if all_passed:
        print("✓ All tests passed!")
        print("\nYou can now:")
        print("1. Run: ./transcribe.sh")
        print("2. Drop video files into: ~/Downloads/whisper_drop")
        print("3. Copy YouTube URLs to transcribe them")
    else:
        print("✗ Some tests failed. Please check the errors above.")
    print("=" * 60)

    return 0 if all_passed else 1

if __name__ == "__main__":
    sys.exit(main())
