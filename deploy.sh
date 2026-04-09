#!/bin/bash

# Load environment variables
[ -f ".env" ] && source .env

# Set variables from arguments or .env
ROKU_IP=${1:-$ROKU_IP}
ROKU_PASSWORD=${2:-$ROKU_PASSWORD}
ROKU_USER="rokudev"

# Prompt for missing credentials
[ -z "$ROKU_IP" ] && read -p "Roku IP: " ROKU_IP
[ -z "$ROKU_PASSWORD" ] && read -s -p "Roku Password: " ROKU_PASSWORD && echo

# Determine next build number and output path
mkdir -p dist
LAST_NUM=$(ls dist/build_*.zip 2>/dev/null | sed -E 's/.*build_([0-9]+)\.zip/\1/' | sort -n | tail -1)
NEXT_NUM=$(( ${LAST_NUM:-0} + 1 ))
OUTPUT_FILE="dist/build_${NEXT_NUM}.zip"

# Create zip archive
echo "Zipping to $OUTPUT_FILE..."
zip -rq9 "$OUTPUT_FILE" . -x "dist/*" "*.zip" "*.pkg" ".*" "*/.*"

# Deploy to Roku
echo "Deploying to $ROKU_IP..."
RESPONSE=$(curl --anyauth -u "$ROKU_USER:$ROKU_PASSWORD" \
    -s -w "%{http_code}" -o /dev/null \
    -F "mysubmit=Replace" \
    -F "archive=@$OUTPUT_FILE" \
    "http://$ROKU_IP/plugin_install")

# Check deployment response
if [ "$RESPONSE" -eq 200 ]; then
    echo "Success!"
else
    echo "Error! HTTP Status: $RESPONSE"
fi
