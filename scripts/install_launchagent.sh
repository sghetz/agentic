#!/usr/bin/env bash
set -euo pipefail

# Installs the compiled server binary and registers it as a per-user
# launchd LaunchAgent that starts at login and restarts if it exits
# (RunAtLoad + KeepAlive). Run scripts/build_server.sh first.
#
# This makes a persistent system change (survives reboot, starts
# automatically) -- run it deliberately, not as part of an automated build.

cd "$(dirname "$0")/.."

BUNDLE_SRC="build/server/bundle"
if [ ! -f "$BUNDLE_SRC/bin/server" ]; then
  echo "Run scripts/build_server.sh first (missing $BUNDLE_SRC/bin/server)" >&2
  exit 1
fi

INSTALL_BASE="$HOME/Library/Application Support/Agentic"
LOG_DIR="$HOME/Library/Logs/Agentic"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
PLIST_DEST="$LAUNCH_AGENTS_DIR/com.agentic.server.plist"

mkdir -p "$INSTALL_BASE" "$LOG_DIR" "$LAUNCH_AGENTS_DIR"
# The whole bundle (bin/ + lib/), not just the binary -- it loads
# lib/libsqlite3.dylib via a path relative to its own location.
rm -rf "$INSTALL_BASE/bin" "$INSTALL_BASE/lib"
cp -R "$BUNDLE_SRC/bin" "$INSTALL_BASE/bin"
cp -R "$BUNDLE_SRC/lib" "$INSTALL_BASE/lib"
chmod +x "$INSTALL_BASE/bin/server"

sed -e "s#__BIN_PATH__#$INSTALL_BASE/bin/server#" \
    -e "s#__LOG_DIR__#$LOG_DIR#" \
    packaging/com.agentic.server.plist > "$PLIST_DEST"

# Unload first in case a previous version is already running -- `load`
# alone would fail with "already loaded" on a reinstall.
launchctl unload "$PLIST_DEST" 2>/dev/null || true
launchctl load "$PLIST_DEST"

echo "Installed and started com.agentic.server"
echo "Binary: $INSTALL_BASE/bin/server"
echo "Logs:   $LOG_DIR/server.log"
echo "Run scripts/uninstall_launchagent.sh to remove it."
