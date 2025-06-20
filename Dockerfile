FROM python:3.10-slim

WORKDIR /app

# Install required packages
RUN apt-get update && apt-get install -y \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgl1 \
    curl && \
    rm -rf /var/lib/apt/lists/*

# Install Python deps
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy script and model download step
COPY gdrive-download.sh ./
RUN chmod +x ./gdrive-download.sh && \
    mkdir -p /assets && \
    ./gdrive-download.sh 1AbhKB8d-saS6KENc9psmIv5O5j5jGHOy /assets/checkpoint_enhanced_fine.keras

RUN ls -lh /assets

# Copy app code
COPY . .

EXPOSE 5000
CMD ["python", "app.py"]
