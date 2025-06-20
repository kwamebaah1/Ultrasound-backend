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
    curl && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Add Google Drive download script
COPY gdrive-download.sh .
RUN chmod +x ./gdrive-download.sh && \
    mkdir -p /assets && \
    ./gdrive-download.sh 1AbhKB8d-saS6KENc9psmIv5O5j5jGHOy /assets/checkpoint_enhanced_fine.keras && \
    ls -lh /assets

# Copy the rest of your app
COPY . .

# Expose port
EXPOSE 5000

# Run your Flask app
CMD ["python", "app.py"]
