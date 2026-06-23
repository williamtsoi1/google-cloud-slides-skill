#!/usr/bin/env bash
#
# html_to_pdf.sh — Render a Google Cloud slide deck (single self-contained HTML file)
# to a multi-page PDF, one slide per page.
#
# Built for CLI agents (Claude Code, Antigravity CLI, Gemini CLI) that lack a built-in
# slide-export capability. Uses system Chrome/Chromium headless when available, and falls
# back to Playwright otherwise.
#
# The deck HTML must use the print CSS from references/CSS_SNIPPETS.md so that each
# `.slide` section maps to exactly one PDF page (an `@page { size: 1280px 720px }` rule
# and per-slide `page-break-after`). Page size and margins come from that CSS, not from
# flags here.
#
# Usage:
#   html_to_pdf.sh <input.html> [output.pdf]
#
# Environment:
#   CHROME_BIN   Override the Chrome/Chromium binary to use.
#
set -euo pipefail

die() { printf 'html_to_pdf: %s\n' "$1" >&2; exit 1; }

[ $# -ge 1 ] || die "usage: html_to_pdf.sh <input.html> [output.pdf]"

IN="$1"
[ -f "$IN" ] || die "input file not found: $IN"

# Resolve the input to an absolute path (portable; no realpath dependency).
IN_DIR="$(cd "$(dirname "$IN")" && pwd)"
IN_BASE="$(basename "$IN")"
IN_ABS="$IN_DIR/$IN_BASE"

# Default output: input basename with .pdf extension, in the current directory.
if [ $# -ge 2 ]; then
  OUT="$2"
else
  OUT="${IN_BASE%.*}.pdf"
fi
# Resolve output to an absolute path so Chrome writes where the user expects.
OUT_DIR="$(cd "$(dirname "$OUT")" && pwd)"
OUT_ABS="$OUT_DIR/$(basename "$OUT")"

FILE_URL="file://$IN_ABS"

# --- Locate a Chrome/Chromium binary -----------------------------------------
find_chrome() {
  # 1. Explicit override.
  if [ -n "${CHROME_BIN:-}" ]; then
    [ -x "$CHROME_BIN" ] && { printf '%s' "$CHROME_BIN"; return 0; }
    return 1
  fi
  # 2. On PATH.
  local c
  for c in google-chrome google-chrome-stable chromium chromium-browser; do
    if command -v "$c" >/dev/null 2>&1; then
      command -v "$c"; return 0
    fi
  done
  # 3. Well-known macOS application paths.
  local p
  for p in \
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
    "/Applications/Chromium.app/Contents/MacOS/Chromium" \
    "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge" \
    "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"; do
    [ -x "$p" ] && { printf '%s' "$p"; return 0; }
  done
  return 1
}

# --- Chrome path -------------------------------------------------------------
render_with_chrome() {
  local chrome="$1"
  # A throwaway profile dir avoids touching the user's real Chrome profile.
  local tmp
  tmp="$(mktemp -d 2>/dev/null || echo "${TMPDIR:-/tmp}/html_to_pdf.$$")"
  mkdir -p "$tmp"
  "$chrome" \
    --headless=new \
    --disable-gpu \
    --no-sandbox \
    --no-first-run \
    --no-pdf-header-footer \
    --user-data-dir="$tmp" \
    --run-all-compositor-stages-before-draw \
    --virtual-time-budget=10000 \
    --print-to-pdf="$OUT_ABS" \
    "$FILE_URL" >/dev/null 2>&1
  local rc=$?
  rm -rf "$tmp" 2>/dev/null || true
  return $rc
}

# --- Playwright fallback -----------------------------------------------------
# Reads the file URL + output path from argv. Honors @page size via
# prefer_css_page_size and prints backgrounds so brand colors survive.
PLAYWRIGHT_PY='
import sys
from playwright.sync_api import sync_playwright

file_url, out = sys.argv[1], sys.argv[2]
with sync_playwright() as p:
    browser = p.chromium.launch()
    page = browser.new_page()
    page.goto(file_url, wait_until="networkidle")
    page.pdf(path=out, prefer_css_page_size=True, print_background=True)
    browser.close()
'

render_with_playwright() {
  # Prefer uv (auto-installs playwright into an ephemeral env), then a system
  # python3 that already has playwright importable.
  if command -v uv >/dev/null 2>&1; then
    uv run --with playwright python -m playwright install chromium >/dev/null 2>&1 || true
    uv run --with playwright python - "$FILE_URL" "$OUT_ABS" <<PY
$PLAYWRIGHT_PY
PY
    return $?
  fi
  if command -v python3 >/dev/null 2>&1 && python3 -c "import playwright" >/dev/null 2>&1; then
    python3 -m playwright install chromium >/dev/null 2>&1 || true
    python3 - "$FILE_URL" "$OUT_ABS" <<PY
$PLAYWRIGHT_PY
PY
    return $?
  fi
  return 127
}

# --- Drive -------------------------------------------------------------------
if CHROME="$(find_chrome)"; then
  echo "html_to_pdf: rendering with Chrome ($CHROME)" >&2
  if render_with_chrome "$CHROME" && [ -s "$OUT_ABS" ]; then
    echo "html_to_pdf: wrote $OUT_ABS" >&2
    exit 0
  fi
  echo "html_to_pdf: Chrome render failed, trying Playwright fallback..." >&2
fi

echo "html_to_pdf: rendering with Playwright..." >&2
if render_with_playwright && [ -s "$OUT_ABS" ]; then
  echo "html_to_pdf: wrote $OUT_ABS" >&2
  exit 0
fi

die "no working renderer found. Install Google Chrome, or set up Playwright:
  uv run --with playwright playwright install chromium"
