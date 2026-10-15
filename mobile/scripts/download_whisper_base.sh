#!/usr/bin/env bash
set -e

# DinarWise Whisper Base Model Download Script
# This downloads the optional ggml-base.bin model (141 MB) from HuggingFace
# Note: ggml-tiny.bin (74 MB) is tracked in Git and bundled by default.

TARGET_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../android/app/src/main/assets/models" && pwd)"
mkdir -p "$TARGET_DIR"

MODEL_FILE="$TARGET_DIR/ggml-base.bin"
EXPECTED_SIZE=147951465
URL="https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.bin"

if [ -f "$MODEL_FILE" ]; then
    CURRENT_SIZE=$(wc -c < "$MODEL_FILE" | tr -d ' ')
    if [ "$CURRENT_SIZE" -eq "$EXPECTED_SIZE" ]; then
        echo "ggml-base.bin already exists and matches expected size ($EXPECTED_SIZE bytes)."
        exit 0
    else
        echo "Existing ggml-base.bin size ($CURRENT_SIZE) does not match expected size ($EXPECTED_SIZE). Re-downloading..."
    fi
fi

echo "Downloading ggml-base.bin (141 MB) from $URL..."
curl -L "$URL" -o "$MODEL_FILE"

DOWNLOADED_SIZE=$(wc -c < "$MODEL_FILE" | tr -d ' ')
if [ "$DOWNLOADED_SIZE" -ne "$EXPECTED_SIZE" ]; then
    echo "Error: Downloaded file size ($DOWNLOADED_SIZE) does not match expected size ($EXPECTED_SIZE)!"
    exit 1
fi

echo "Successfully verified ggml-base.bin in $MODEL_FILE"
