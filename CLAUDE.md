# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

This is a **Claude Code skill** (not a runnable application) that teaches Claude how to generate Google Cloud-branded slide decks. It contains no executable code — only markdown instructions, CSS references, and image assets. The skill is invoked via the `slides` tool in `html` mode.

## Repo Structure

- `SKILL.md` — The skill definition file (frontmatter + instructions). This is the entry point that Claude loads when the skill is activated.
- `references/LAYOUTS.md` — Catalog of all available slide layout types (cover, section dividers, content, charts, statements, images, maps, closing).
- `references/CSS_SNIPPETS.md` — CSS variable definitions and class patterns for implementing the Google Cloud 2025 visual style in HTML.
- `templates/` — Brand assets: `gradient_super_cloud_512_2x.png` (multicolour cloud logo), `GC_Progress_Bar_Gradient_RGB.jpg` (rainbow divider bar).
- `scripts/` — Currently empty; reserved for future tooling.

## Key Brand Rules

When editing or extending this skill, maintain these constraints:

- The Google Cloud icon must always be referenced from `templates/gradient_super_cloud_512_2x.png` — never recreated with CSS arcs.
- The rainbow divider bar must always use the image asset at `templates/GC_Progress_Bar_Gradient_RGB.jpg` — never recreated with CSS gradients.
- Every slide must have a footer: "Google Cloud" bottom-left, "Proprietary & Confidential [page#]" bottom-right.
- Section numbers are always zero-padded two digits (01, 02, 03).
- Bullet slides: max 6-8 items, no trailing punctuation.
- Color palette uses exactly: `#3186FF` (Blue), `#FC413D` (Red), `#FEC700` (Yellow), `#00AF57` (Green), `#202124` (Dark), `#FFFFFF` (Light).
