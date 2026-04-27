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

# Create a temp file for the response body
TEMP_RESPONSE=$(mktemp)

HTTP_CODE=$(curl --anyauth -u "$ROKU_USER:$ROKU_PASSWORD" \
    -s -w "%{http_code}" \
    -F "mysubmit=Replace" \
    -F "archive=@$OUTPUT_FILE" \
    -o "$TEMP_RESPONSE" \
    "http://$ROKU_IP/plugin_install")

# Check deployment response
if [ "$HTTP_CODE" -eq 200 ]; then
    # Roku returns "Install Success" or "Update Success" in HTML body
    if grep -qiE "Install Success|Update Success" "$TEMP_RESPONSE"; then
        echo "Success!"
    else
        echo "Error: Roku returned 200, but installation failed."
        
        # Витягуємо текст помилки, очищуючи його від HTML-тегів та зайвих пробілів
        ERROR_MSG=$(grep -oi "<font color=\"red\">.*</font>" "$TEMP_RESPONSE" | sed 's/<[^>]*>//g' | xargs)
        
        if [ -n "$ERROR_MSG" ]; then
            echo "Details: $ERROR_MSG"
        else
            echo "Details: Could not parse error message. Please check the Roku Web UI."
        fi
    fi
else
    echo "HTTP Error! Status: $HTTP_CODE"
fi

# Cleanup
rm -f "$TEMP_RESPONSE"
