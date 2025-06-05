#!/bin/bash

# Usage: ./localtunnel_transfer.sh "file1,folder2,file3" 8080

INPUT=$1
PORT=$2
ZIP_FILE="transfert_pack.zip"
SHORT_URL="short_url.txt"
QR_FILE="short_url_qr.png"
LT_LOG="lt_output.log"

# Required tools check
for cmd in curl zip python3 lt gnome-terminal; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "❌ Required command '$cmd' not found. Please install it."
    exit 1
  fi
done

# Optional QR
QR_ENABLED=false
if command -v qrencode >/dev/null 2>&1; then
  QR_ENABLED=true
fi

# Clean up
rm -f "$ZIP_FILE" "$SHORT_URL" "$QR_FILE" "$LT_LOG"

# Process files
IFS=',' read -ra ITEMS <<< "$INPUT"
for ITEM in "${ITEMS[@]}"; do
  ITEM=$(echo "$ITEM" | xargs)
  BASENAME=$(basename "$ITEM")

  if [ -e "$ITEM" ]; then
    if [ -d "$ITEM" ]; then
      echo "📦 Zipping folder: $BASENAME"
      zip -r "$BASENAME.zip" "$ITEM" > /dev/null
    elif [ "$ITEM" != "./$BASENAME" ]; then
      echo "📄 Copying file: $BASENAME"
      cp "$ITEM" .
    else
      echo "📄 File $BASENAME already in current directory, skipping copy"
    fi
  else
    echo "⚠️ Warning: '$ITEM' not found"
  fi
done

echo "📦 Creating final zip package: $ZIP_FILE"
zip -r "$ZIP_FILE" . -i "*" > /dev/null

# Start Python HTTP server in a new terminal
echo "🚀 Starting HTTP server on port $PORT in new terminal..."
gnome-terminal -- bash -c "python3 -m http.server $PORT --bind 127.0.0.1; exec bash"
sleep 3

# Start localtunnel in new terminal and log output
echo "☁ Starting localtunnel in new terminal..."
gnome-terminal -- bash -c "lt --port $PORT | tee \"$LT_LOG\"; exec bash"

# Wait for localtunnel URL
echo "🔍 Waiting for LocalTunnel URL..."
LT_URL=""
for i in {1..30}; do
  sleep 2
  LT_URL=$(grep -oE 'https://[a-zA-Z0-9.-]+\.loca\.lt' "$LT_LOG" | head -n1)
  if [ -n "$LT_URL" ]; then
    break
  fi
done

if [ -z "$LT_URL" ]; then
  echo "❌ Could not retrieve LocalTunnel URL"
  exit 1
fi

FINAL_LINK="$LT_URL/$ZIP_FILE"
echo "✅ Public URL: $FINAL_LINK"
echo "$FINAL_LINK" > "$SHORT_URL"

# QR code generation
if [ "$QR_ENABLED" = true ]; then
  echo "📱 Generating QR code..."
  qrencode -o "$QR_FILE" "$FINAL_LINK"
  echo "📂 Opening QR code in new terminal..."
  gnome-terminal -- bash -c "xdg-open \"$QR_FILE\"; exec bash"
else
  echo "⚠️ qrencode not installed — skipping QR code generation"
fi

# Open final link in new terminal
echo "🌐 Opening download link in browser..."
gnome-terminal -- bash -c "xdg-open \"$FINAL_LINK\"; exec bash"

echo "✅ Transfer ready!"
exit 0

