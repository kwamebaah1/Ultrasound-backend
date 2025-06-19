# Use Python 3.10 base image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgl1 \
    curl \
    unzip && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Create assets folder and download model from Google Drive
RUN mkdir -p /app/assets && \
    curl -c cookies.txt -s -L "https://drive.google.com/uc?export=download&id=1AbhKB8d-saS6KENc9psmIv5O5j5jGHOy" > temp.html && \
    curl -Lb cookies.txt -s -o /app/assets/checkpoint_enhanced_fine.keras "$(cat temp.html | grep -oP 'uc\?export=download[^"]+' | head -n 1 | sed 's/&amp;/\&/g')"

# Copy the rest of the app
COPY . .

# Expose port
EXPOSE 5000

# Start the app
CMD ["python", "app.py"]
