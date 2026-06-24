#!/usr/bin/env bash
#
# build_gslides.sh — Build a Google Cloud-branded .pptx from a JSON deck spec.
#
# The .pptx is meant to be uploaded to Google Drive and opened as Google Slides,
# which converts it to a native, editable deck. There is no upload/auth here — the
# upload is a manual step (see SKILL.md "Exporting to Google Slides").
#
# Built for CLI agents (Claude Code, Antigravity CLI, Gemini CLI). Runs the Python
# builder with `uv` (auto-installs python-pptx into an ephemeral env) when available,
# and falls back to a system python3 that already has python-pptx importable.
#
# The deck JSON schema and supported slide types are documented in
# references/GSLIDES_SPEC.md.
#
# Usage:
#   build_gslides.sh <deck.json> [output.pptx]
#
set -euo pipefail

die() { printf 'build_gslides: %s\n' "$1" >&2; exit 1; }

[ $# -ge 1 ] || die "usage: build_gslides.sh <deck.json> [output.pptx]"

IN="$1"
[ -f "$IN" ] || die "deck spec not found: $IN"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILDER="$SCRIPT_DIR/build_gslides.py"
[ -f "$BUILDER" ] || die "builder not found: $BUILDER"

# Resolve input to an absolute path (portable; no realpath dependency).
IN_DIR="$(cd "$(dirname "$IN")" && pwd)"
IN_ABS="$IN_DIR/$(basename "$IN")"

# Default output: input basename with .pdf->.pptx, in the current directory.
if [ $# -ge 2 ]; then
  OUT="$2"
else
  OUT="$(basename "${IN%.*}").pptx"
fi
OUT_DIR="$(cd "$(dirname "$OUT")" && pwd)"
OUT_ABS="$OUT_DIR/$(basename "$OUT")"

# 1. uv — auto-provisions python-pptx into an ephemeral environment.
if command -v uv >/dev/null 2>&1; then
  uv run --with python-pptx python "$BUILDER" "$IN_ABS" "$OUT_ABS"
  exit $?
fi

# 2. System python3 that already has python-pptx importable.
if command -v python3 >/dev/null 2>&1 && python3 -c "import pptx" >/dev/null 2>&1; then
  python3 "$BUILDER" "$IN_ABS" "$OUT_ABS"
  exit $?
fi

die "no Python with python-pptx found. Install uv (recommended), or:
  pip install python-pptx"
