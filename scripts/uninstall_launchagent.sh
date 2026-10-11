#!/usr/bin/env bash
set -euo pipefail

# Stops and removes the com.agentic.server LaunchAgent. Leaves the compiled
# binary and app data (~/Library/Application Support/Agentic) in place --
# only undoes what install_launchagent.sh registered with launchd.

PLIST_DEST="$HOME/Library/LaunchAgents/com.agentic.server.plist"

if [ -f "$PLIST_DEST" ]; then
  launchctl unload "$PLIST_DEST" 2>/dev/null || true
  rm -f "$PLIST_DEST"
  echo "Unloaded and removed $PLIST_DEST"
else
  echo "Not installed ($PLIST_DEST not found)"
fi
