#!/usr/bin/env bash
# Run from workspace parent (folder that contains AI-SKILLS/). Same idea as setup-windows.bat at parent on Windows.
set -euo pipefail

PARENT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
REPO=""

for candidate in "$PARENT"/*; do
  [[ -d "$candidate" ]] || continue
  if [[ -f "$candidate/scripts/setup-macos-linux.sh" ]]; then
    REPO="$(cd "$candidate" && pwd)"
    break
  fi
done

if [[ -z "$REPO" ]]; then
  echo "No clone with scripts/setup-macos-linux.sh found under:"
  echo "  $PARENT"
  exit 1
fi

echo ""
echo "Workspace: $PARENT"
echo "Clone:     $REPO"
echo ""

export WORKSPACE_ROOT="$PARENT"
exec "$REPO/scripts/setup-macos-linux.sh"
