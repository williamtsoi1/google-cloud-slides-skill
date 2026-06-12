# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

This is a **skill that ships as both a Claude Code plugin and a Gemini CLI extension** (not a runnable application). It teaches the agent how to generate Google Cloud-branded slide decks. It contains no executable code — only markdown instructions, CSS references, and image assets. The skill is invoked via the `slides` tool in `html` mode.

Both platforms discover the same `skills/<name>/SKILL.md` convention, so a single shared `skills/` directory serves both. Each platform has its own manifest at a fixed location.

## Repo Structure

- `.claude-plugin/plugin.json` — Claude Code plugin manifest (name, description, version, author, repository).
- `.claude-plugin/marketplace.json` — One-plugin marketplace so the repo is directly installable via `/plugin marketplace add`.
- `gemini-extension.json` — Gemini CLI extension manifest (name must match the install directory).
- `skills/google-cloud-slides/SKILL.md` — The skill definition file (frontmatter + instructions). This is the entry point the agent loads when the skill is activated.
- `skills/google-cloud-slides/references/LAYOUTS.md` — Catalog of all available slide layout types (cover, section dividers, content, charts, statements, images, maps, closing).
- `skills/google-cloud-slides/references/CSS_SNIPPETS.md` — CSS variable definitions and class patterns for implementing the Google Cloud 2025 visual style in HTML.
- `skills/google-cloud-slides/templates/` — Brand assets: `gradient_super_cloud_512_2x.png` (multicolour cloud logo), `GC_Progress_Bar_Gradient_RGB.jpg` (rainbow divider bar). Referenced relatively from `SKILL.md`, so they move with the skill.
- `scripts/` — Currently empty; reserved for future tooling.
- `README.md` — Install instructions for both Claude Code and Gemini CLI.

## Key Brand Rules

When editing or extending this skill, maintain these constraints:

- The Google Cloud icon must always be referenced from `skills/google-cloud-slides/templates/gradient_super_cloud_512_2x.png` (relative path `templates/gradient_super_cloud_512_2x.png` from `SKILL.md`) — never recreated with CSS arcs.
- The rainbow divider bar must always use the image asset at `skills/google-cloud-slides/templates/GC_Progress_Bar_Gradient_RGB.jpg` (relative path `templates/GC_Progress_Bar_Gradient_RGB.jpg` from `SKILL.md`) — never recreated with CSS gradients.
- Every slide must have a footer: "Google Cloud" bottom-left, "Proprietary & Confidential [page#]" bottom-right.
- Section numbers are always zero-padded two digits (01, 02, 03).
- Bullet slides: max 6-8 items, no trailing punctuation.
- Color palette uses exactly: `#3186FF` (Blue), `#FC413D` (Red), `#FEC700` (Yellow), `#00AF57` (Green), `#202124` (Dark), `#FFFFFF` (Light).
