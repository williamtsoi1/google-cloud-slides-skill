# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

This is a **skill that ships as both a Claude Code plugin and a Gemini CLI extension** (not a runnable application). It teaches the agent how to generate Google Cloud-branded slide decks. It is mostly markdown instructions, CSS references, and image assets, plus bundled scripts for export. On Manus the skill is invoked via the `slides` tool in `html` mode and the platform handles export. In CLI environments (Claude Code, Antigravity CLI, Gemini CLI) there is no built-in export, so the skill provides two export paths:

- **HTML → PDF** (flat, pixel-accurate, real Google Sans): the agent writes a single self-contained HTML deck (each slide a `.slide` section with the Print/PDF CSS) and runs `skills/google-cloud-slides/scripts/html_to_pdf.sh`.
- **JSON → PPTX → Google Slides** (native, editable): the agent writes a JSON deck spec and runs `skills/google-cloud-slides/scripts/build_gslides.sh` to produce a `.pptx`; the user uploads it to Drive, which converts it to editable Slides. This path uses **Roboto** instead of Google Sans (see Key Brand Rules).

Both platforms discover the same `skills/<name>/SKILL.md` convention, so a single shared `skills/` directory serves both. Each platform has its own manifest at a fixed location.

## Commands

There is no build, test, or lint suite — the repo is markdown/CSS/assets plus one shell script. The commands that matter:

```bash
# Validate the plugin and all manifests (run after editing any .json or SKILL.md)
claude plugin validate .

# Render a single-file HTML deck to a multi-page PDF (one slide per page)
bash skills/google-cloud-slides/scripts/html_to_pdf.sh deck.html deck.pdf

# Verify page count == slide count (a doubled count means a screen-only
# margin/shadow leaked into print — fix the @media print reset in CSS_SNIPPETS.md)
mdls -name kMDItemNumberOfPages deck.pdf   # macOS
pdfinfo deck.pdf | grep Pages              # Linux (poppler-utils)

# Build an editable Google Slides deck: JSON spec -> .pptx (then user uploads to Drive)
bash skills/google-cloud-slides/scripts/build_gslides.sh \
  skills/google-cloud-slides/scripts/examples/sample_deck.json /tmp/sample.pptx
```

`html_to_pdf.sh` tries system Chrome/Chromium (`--headless --print-to-pdf`) first and falls back to Playwright (`uv run --with playwright`); override the browser with `CHROME_BIN`.

`build_gslides.sh` runs `build_gslides.py` via `uv run --with python-pptx` (or a system `python3` with `python-pptx` importable). It is offline — no Drive API, no auth. The JSON schema and supported slide types live in `references/GSLIDES_SPEC.md`. Note: if a machine has a private default PyPI index configured (e.g. via `UV_INDEX_URL`/pip config), `uv` may fail to find `python-pptx`; that is an environment quirk, not a script bug.

## Repo Structure

- `.claude-plugin/plugin.json` — Claude Code plugin manifest (name, description, version, author, repository).
- `.claude-plugin/marketplace.json` — One-plugin marketplace so the repo is directly installable via `/plugin marketplace add`.
- `gemini-extension.json` — Gemini CLI extension manifest (name must match the install directory).
- `skills/google-cloud-slides/SKILL.md` — The skill definition file (frontmatter + instructions). This is the entry point the agent loads when the skill is activated.
- `skills/google-cloud-slides/references/LAYOUTS.md` — Catalog of all available slide layout types (cover, section dividers, content, charts, statements, images, maps, closing).
- `skills/google-cloud-slides/references/CSS_SNIPPETS.md` — CSS variable definitions and class patterns for implementing the Google Cloud 2025 visual style in HTML.
- `skills/google-cloud-slides/references/GSLIDES_SPEC.md` — The JSON deck-spec schema and supported slide types consumed by `build_gslides.py` (the contract the agent authors against for the Google Slides path).
- `skills/google-cloud-slides/templates/` — Brand assets: `gradient_super_cloud_512_2x.png` (multicolour cloud logo), `GC_Progress_Bar_Gradient_RGB.jpg` (rainbow divider bar). Referenced relatively from `SKILL.md` and embedded from disk by `build_gslides.py`, so they move with the skill.
- `skills/google-cloud-slides/scripts/html_to_pdf.sh` — PDF converter bundled with the skill (travels with the plugin/extension, like `templates/`). Renders a single-file HTML deck to a multi-page PDF (one slide per page) using system Chrome/Chromium headless, with a Playwright fallback. Used by CLI agents that lack Manus's built-in export.
- `skills/google-cloud-slides/scripts/build_gslides.sh` + `build_gslides.py` — Google Slides exporter bundled with the skill. The `.py` builds a `.pptx` from a JSON deck spec with `python-pptx` (one `render_*` function per layout type, brand constants/footer/section numbers enforced in code, brand images embedded from `templates/`); the `.sh` wrapper provisions `python-pptx` via `uv`. Offline — the user converts the `.pptx` to Slides in Drive.
- `skills/google-cloud-slides/scripts/examples/sample_deck.json` — Reference deck spec exercising the core layouts; used for verification.
- `scripts/` — Repo-root scripts; reserved for future tooling. (The PDF converter lives inside the skill, not here, so it ships with the skill.)
- `README.md` — Install instructions for both Claude Code and Gemini CLI.

The three manifests (`.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, `gemini-extension.json`) each carry their own `name`/`description`/`version` and must be kept in sync by hand when bumping a release — there is no shared source. `plugin.json` and `gemini-extension.json` are both at 1.1.0 (`marketplace.json` carries no version); update all of them together on the next bump. The `SKILL.md` `description` frontmatter, the `plugin.json` `description`, and the `marketplace.json` plugin `description` should also match.

## Key Brand Rules

When editing or extending this skill, maintain these constraints:

- The Google Cloud icon must always be referenced from `skills/google-cloud-slides/templates/gradient_super_cloud_512_2x.png` (relative path `templates/gradient_super_cloud_512_2x.png` from `SKILL.md`) — never recreated with CSS arcs.
- The rainbow divider bar must always use the image asset at `skills/google-cloud-slides/templates/GC_Progress_Bar_Gradient_RGB.jpg` (relative path `templates/GC_Progress_Bar_Gradient_RGB.jpg` from `SKILL.md`) — never recreated with CSS gradients.
- Every slide must have a footer: "Google Cloud" bottom-left, "Proprietary & Confidential [page#]" bottom-right.
- Section numbers are always zero-padded two digits (01, 02, 03).
- Bullet slides: max 6-8 items, no trailing punctuation.
- Color palette uses exactly: `#3186FF` (Blue), `#FC413D` (Red), `#FEC700` (Yellow), `#00AF57` (Green), `#202124` (Dark), `#FFFFFF` (Light).
- **Font.** The HTML/PDF path uses Google Sans. The Google Slides (PPTX) path uses **Roboto** instead — a deliberate, unavoidable exception: Google Sans is proprietary (not in the Google Slides font library) and Slides ignores fonts embedded in a `.pptx` on import, so an *editable* Slides deck cannot render Google Sans. Roboto is Google's own typeface and the closest free relative. Do not "fix" this by rasterizing text (kills editability) or by embedding the font (Slides ignores it). The font constant lives in `build_gslides.py` (`FONT = "Roboto"`).
