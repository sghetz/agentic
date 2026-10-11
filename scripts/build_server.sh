#!/usr/bin/env bash
set -euo pipefail

# Compiles the server to a native binary -- no Dart VM needed at runtime.
# Uses `dart build cli`, not `dart compile exe`: the latter doesn't support
# packages with native build hooks, and sqlite3 (via drift) has one to
# bundle its native library. `dart build cli` produces a bundle/ directory
# (bin/server + lib/libsqlite3.dylib) rather than a single standalone file
# -- the two must stay together, the binary loads the dylib via a relative
# path. Run from anywhere; always operates relative to the repo root.

cd "$(dirname "$0")/.."

OUT_DIR="build/server"

echo "Compiling server..."
dart build cli --target packages/server/bin/server.dart -o "$OUT_DIR"

echo "Built $OUT_DIR/bundle/bin/server (with $OUT_DIR/bundle/lib/)"
