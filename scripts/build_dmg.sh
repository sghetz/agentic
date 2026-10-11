#!/usr/bin/env bash
set -euo pipefail

# Builds the Flutter macOS app in release mode and packages it into an
# unsigned DMG -- unsigned is fine for personal use, per docs/ARCHITECTURE.md
# §10. Run from anywhere; always operates relative to the repo root.

cd "$(dirname "$0")/.."

echo "Building Flutter macOS app (release)..."
(cd packages/app && flutter build macos --release)

APP_PATH="packages/app/build/macos/Build/Products/Release/Agentic.app"
if [ ! -d "$APP_PATH" ]; then
  echo "Build did not produce $APP_PATH" >&2
  exit 1
fi

OUT_DIR="build/dmg"
mkdir -p "$OUT_DIR"
DMG_PATH="$OUT_DIR/Agentic.dmg"
rm -f "$DMG_PATH"

echo "Creating DMG..."
hdiutil create -volname "Agentic" -srcfolder "$APP_PATH" -ov -format UDZO "$DMG_PATH"

echo "Built $DMG_PATH"
