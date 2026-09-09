#!/usr/bin/env bash
# Sets up the local (self-hosted) AI needed for DinarWise receipt scanning.
#
# Safe to re-run. It never uninstalls anything and never overwrites values in .env
# other than the model name it selects for you.
#
#   ./scripts/setup_ai_demo.sh
#
set -uo pipefail

BACKEND_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$BACKEND_DIR/.env"
OLLAMA_HOST_URL="${DINARWISE_OLLAMA_BASE_URL:-http://127.0.0.1:11434}"

bold()  { printf '\033[1m%s\033[0m\n' "$1"; }
good()  { printf '\033[32m✓\033[0m %s\n' "$1"; }
warn()  { printf '\033[33m!\033[0m %s\n' "$1"; }
bad()   { printf '\033[31m✗\033[0m %s\n' "$1"; }
step()  { printf '\n\033[1m▸ %s\033[0m\n' "$1"; }

echo
bold "DinarWise — local receipt AI setup"
echo "Everything installed here runs on this machine. No receipt data leaves it."

# ---------------------------------------------------------------------------
step "1/5  Checking for Ollama"
# ---------------------------------------------------------------------------
if ! command -v ollama >/dev/null 2>&1; then
  bad "Ollama is not installed. It is the free tool that runs the AI model locally."
  echo
  case "$(uname -s)" in
    Darwin)
      echo "  Install it one of these ways, then re-run this script:"
      echo "    brew install ollama"
      echo "  or download the Mac app from  https://ollama.com/download"
      ;;
    Linux)
      echo "  Install it with, then re-run this script:"
      echo "    curl -fsSL https://ollama.com/install.sh | sh"
      ;;
    *)
      echo "  Download it from  https://ollama.com/download  then re-run this script."
      ;;
  esac
  echo
  exit 1
fi
good "Ollama is installed ($(ollama --version 2>/dev/null | head -n1))"

# ---------------------------------------------------------------------------
step "2/5  Making sure the Ollama service is running"
# ---------------------------------------------------------------------------
if curl -fsS --max-time 5 "$OLLAMA_HOST_URL/api/tags" >/dev/null 2>&1; then
  good "Service is already responding at $OLLAMA_HOST_URL"
else
  warn "Not responding yet — starting it in the background"
  nohup ollama serve >/tmp/dinarwise-ollama.log 2>&1 &
  for _ in $(seq 1 30); do
    sleep 1
    if curl -fsS --max-time 5 "$OLLAMA_HOST_URL/api/tags" >/dev/null 2>&1; then
      good "Service is up"
      break
    fi
  done
  if ! curl -fsS --max-time 5 "$OLLAMA_HOST_URL/api/tags" >/dev/null 2>&1; then
    bad "Could not start the Ollama service. Try running 'ollama serve' in another"
    echo "  terminal and watch for errors, then re-run this script."
    echo "  Log: /tmp/dinarwise-ollama.log"
    exit 1
  fi
fi

# ---------------------------------------------------------------------------
step "3/5  Choosing a model that fits this machine"
# ---------------------------------------------------------------------------
# Total memory in GB. On Apple Silicon this is unified memory shared with the GPU.
case "$(uname -s)" in
  Darwin) TOTAL_GB=$(( $(sysctl -n hw.memsize 2>/dev/null || echo 0) / 1073741824 )) ;;
  Linux)  TOTAL_GB=$(( $(awk '/MemTotal/ {print $2}' /proc/meminfo 2>/dev/null || echo 0) / 1048576 )) ;;
  *)      TOTAL_GB=0 ;;
esac
[ "$TOTAL_GB" -gt 0 ] && echo "  Detected about ${TOTAL_GB} GB of memory."

# Ordered best-first. Model tags on the Ollama registry do change over time, so we
# try several rather than hardcoding one and failing if it was renamed.
# qwen2.5vl reads Arabic and English noticeably better than the llava family, which
# matters because Gulf receipts are usually bilingual.
if [ "$TOTAL_GB" -ge 16 ]; then
  CANDIDATES=(qwen2.5vl:7b qwen2.5vl:3b minicpm-v llama3.2-vision:11b llava:7b)
elif [ "$TOTAL_GB" -ge 8 ]; then
  CANDIDATES=(qwen2.5vl:3b minicpm-v llava:7b moondream)
else
  warn "Under 8 GB of memory — expect slow reads and weaker accuracy."
  CANDIDATES=(qwen2.5vl:3b moondream)
fi

INSTALLED="$(ollama list 2>/dev/null | awk 'NR>1 {print $1}')"
CHOSEN=""

for model in "${CANDIDATES[@]}"; do
  if printf '%s\n' "$INSTALLED" | grep -qx -- "$model"; then
    good "$model is already downloaded"
    CHOSEN="$model"
    break
  fi
done

if [ -z "$CHOSEN" ]; then
  for model in "${CANDIDATES[@]}"; do
    echo "  Trying to download $model (a few GB — this is the slow part)…"
    if ollama pull "$model"; then
      good "Downloaded $model"
      CHOSEN="$model"
      break
    fi
    warn "$model was not available, trying the next option"
  done
fi

if [ -z "$CHOSEN" ]; then
  bad "Could not download any vision model. Check your internet connection, or run"
  echo "  'ollama pull qwen2.5vl:7b' manually to see the error."
  exit 1
fi

# ---------------------------------------------------------------------------
step "4/5  Checking the model can actually see images"
# ---------------------------------------------------------------------------
# A 1x1 white PNG. A text-only model errors or ignores the image; a vision model
# accepts it. This catches picking a non-vision model by mistake.
PIXEL="iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8DwHwAFAAH/q842iQAAAABJRU5ErkJggg=="
SMOKE=$(curl -fsS --max-time 300 "$OLLAMA_HOST_URL/api/chat" \
  -H 'Content-Type: application/json' \
  -d "{\"model\":\"$CHOSEN\",\"stream\":false,\"messages\":[{\"role\":\"user\",\"content\":\"Reply with the single word OK.\",\"images\":[\"$PIXEL\"]}]}" 2>&1)

if printf '%s' "$SMOKE" | grep -q '"message"'; then
  good "$CHOSEN accepted an image"
else
  warn "Could not confirm image support. The demo may still work — try it and see."
  echo "  Response was: $(printf '%s' "$SMOKE" | head -c 200)"
fi

# ---------------------------------------------------------------------------
step "5/5  Writing $ENV_FILE"
# ---------------------------------------------------------------------------
if [ ! -f "$ENV_FILE" ]; then
  cp "$BACKEND_DIR/.env.example" "$ENV_FILE"
  good "Created .env from .env.example"
fi

# Replace the model line without touching anything else in the file.
TMP="$(mktemp)"
grep -v '^DINARWISE_OLLAMA_VISION_MODEL=' "$ENV_FILE" > "$TMP"
printf 'DINARWISE_OLLAMA_VISION_MODEL=%s\n' "$CHOSEN" >> "$TMP"
mv "$TMP" "$ENV_FILE"
good "Model set to $CHOSEN"

if [ "$TOTAL_GB" -lt 8 ] && ! grep -q '^DINARWISE_OLLAMA_TIMEOUT_SECONDS=600' "$ENV_FILE"; then
  TMP="$(mktemp)"
  grep -v '^DINARWISE_OLLAMA_TIMEOUT_SECONDS=' "$ENV_FILE" > "$TMP"
  printf 'DINARWISE_OLLAMA_TIMEOUT_SECONDS=600\n' >> "$TMP"
  mv "$TMP" "$ENV_FILE"
  good "Raised the timeout to 10 minutes because memory is tight"
fi

echo
bold "Done. Two things left:"
echo
echo "  1. Start the backend:"
echo "       cd $BACKEND_DIR"
echo "       pip install -e '.[dev]'      # only needed the first time"
echo "       uvicorn app.main:app --reload"
echo
echo "  2. Open the demo in your browser:"
echo "       http://localhost:8000/demo"
echo
echo "Then drop a photo of a receipt on the page. The very first read is slow"
echo "because the model loads into memory; after that it speeds up a lot."
echo
