#!/bin/bash

FILEID=$1
FILENAME=$2

# Fetch the confirmation token and download the file
CONFIRM=$(curl -sc /tmp/cookie "https://drive.google.com/uc?export=download&id=${FILEID}" | \
          grep -o 'confirm=[^&]*' | sed 's/confirm=//')

curl -Lb /tmp/cookie "https://drive.google.com/uc?export=download&confirm=${CONFIRM}&id=${FILEID}" -o "${FILENAME}"
