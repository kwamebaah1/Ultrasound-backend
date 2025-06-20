#!/bin/bash

FILE_ID=$1
DESTINATION=$2

# Get the confirmation token and download the file
CONFIRM=$(curl -sc /tmp/gcookie "https://drive.google.com/uc?export=download&id=${FILE_ID}" | \
           grep -o 'confirm=[^&]*' | sed 's/confirm=//')

curl -Lb /tmp/gcookie "https://drive.google.com/uc?export=download&confirm=${CONFIRM}&id=${FILE_ID}" -o "${DESTINATION}"
