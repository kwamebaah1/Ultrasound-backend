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

# Download model file from Dropbox (force download with ?dl=1)
RUN mkdir -p /assets && \
    curl -L "https://www.dropbox.com/scl/fi/yxo946lqtq6xdd9t3iz6t/checkpoint_enhanced_fine.keras?rlkey=cx4zebv6uhqj7g3547cfmq4wq&st=bzjpg9gn&dl=1" -o /assets/checkpoint_enhanced_fine.keras && \
    ls -lh /assets

# Copy application code
COPY . .

# Expose port
EXPOSE 5000

# Start the Flask app
CMD ["python", "app.py"]