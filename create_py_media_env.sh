#!/bin/bash

# ---------------------------------------------
# Script to set up Python environment for PDF,
# video, audio manipulation and YouTube downloads
# ---------------------------------------------

# Step 1: Create virtual environment
python3 -m venv venv

# Step 2: Activate virtual environment
source venv/bin/activate

# Step 3: Upgrade pip
pip install --upgrade pip

# Step 4: Install main libraries

# PDF libraries
pip install PyPDF2 pdfplumber reportlab

# Video libraries
pip install moviepy opencv-python ffmpeg-python

# Audio libraries
pip install pydub librosa soundfile

# YouTube download libraries
pip install pytube yt-dlp

# Step 5: Confirmation message
echo "Environment ready with PDF, video, audio, and YouTube download libraries installed!"

