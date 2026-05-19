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

RENDERED="$(sed "s|__HOME__|$HOME|g" "$TEMPLATE")"
if [ -f "$OUTPUT" ]; then
  if ! command -v jq &>/dev/null; then
    echo "[install] ERROR: jq is required to merge hooks into existing settings.json"
    exit 1
  fi
  TMP="$(mktemp)"
  jq -s '.[0] * {hooks: .[1].hooks}' "$OUTPUT" <(printf '%s' "$RENDERED") > "$TMP"
  mv "$TMP" "$OUTPUT"
  echo "[install] Merged hooks into existing settings.json (preserved enabledPlugins/marketplaces)"
else
  printf '%s' "$RENDERED" > "$OUTPUT"
  echo "[install] Generated settings.json (HOME=$HOME)"
fi

# --- Ensure hook is executable ---
HOOK="$CLAUDE_DIR/hooks/rtk-rewrite.sh"
if [ -f "$HOOK" ]; then
  chmod +x "$HOOK"
  echo "[install] Hook permissions set: $HOOK"
fi

# --- Install Claude Code plugins ---
if command -v claude &>/dev/null; then
  echo "[install] Adding marketplace: anthropics/claude-plugins-official"
  claude plugin marketplace add anthropics/claude-plugins-official

  echo "[install] Installing plugin: claude-md-management@claude-plugins-official"
  claude plugin install claude-md-management@claude-plugins-official --scope user
else
  echo "[install] WARNING: 'claude' CLI not found. Skipping plugin installation."
fi

echo "[install] Done. Claude Code configuration is ready."
