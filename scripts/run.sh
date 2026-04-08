#!/bin/bash
# Run hdcd-telegram binary. Downloads it first if not present.

set -euo pipefail

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
DATA_DIR="${CLAUDE_PLUGIN_DATA:-$HOME/.claude/plugins/data/hdcd-telegram}"
BINARY="${DATA_DIR}/hdcd-telegram"

# Install if missing
if [ ! -x "$BINARY" ]; then
  bash "${PLUGIN_ROOT}/scripts/setup.sh"
fi

exec "$BINARY" "$@"
