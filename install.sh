#!/usr/bin/env bash
set -euo pipefail

CLAUDE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "[install] Claude Code dotfiles setup"
echo "[install] Target: $CLAUDE_DIR"

# --- Dependency checks ---
if ! command -v jq &>/dev/null; then
  echo "[install] WARNING: jq is not installed. rtk hook requires jq."
  echo "           Install: https://jqlang.github.io/jq/download/"
fi

if ! command -v rtk &>/dev/null; then
  echo "[install] WARNING: rtk is not installed. Install it first:"
  echo "           https://github.com/rtk-ai/rtk#installation"
fi

# --- Generate settings.json from template ---
TEMPLATE="$CLAUDE_DIR/settings.json.template"
OUTPUT="$CLAUDE_DIR/settings.json"

if [ ! -f "$TEMPLATE" ]; then
  echo "[install] ERROR: settings.json.template not found"
  exit 1
fi

sed "s|__HOME__|$HOME|g" "$TEMPLATE" > "$OUTPUT"
echo "[install] Generated settings.json (HOME=$HOME)"

# --- Ensure hook is executable ---
HOOK="$CLAUDE_DIR/hooks/rtk-rewrite.sh"
if [ -f "$HOOK" ]; then
  chmod +x "$HOOK"
  echo "[install] Hook permissions set: $HOOK"
fi

echo "[install] Done. Claude Code configuration is ready."
