#!/bin/bash

FILE_ID=$1
DESTINATION=$2

# Get the confirmation token (for large files)
CONFIRM=$(curl -sc /tmp/gcookie "https://drive.google.com/uc?export=download&id=${FILE_ID}" | \
         grep -o 'confirm=[^&]*' | sed 's/confirm=//')

# Download the actual file using the confirmation token
curl -Lb /tmp/gcookie "https://drive.google.com/uc?export=download&confirm=${CONFIRM}&id=${FILE_ID}" -o "${DESTINATION}"