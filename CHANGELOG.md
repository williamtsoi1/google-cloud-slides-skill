# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- `RELEASING.md` — canonical maintainer release checklist — and an automated
  `.github/workflows/release.yml` that creates a GitHub Release from the matching
  `CHANGELOG.md` section whenever a `v*` tag is pushed. README and CLAUDE.md point to
  the release docs.

## [1.1.0] - 2026-06-24

### Added
- **Google Slides export path.** A bundled builder, `scripts/build_gslides.sh`
  (wrapping `scripts/build_gslides.py`), turns a JSON deck spec into a Google
  Cloud–branded PowerPoint (`.pptx`). Uploading that file to Google Drive and
  opening it as Google Slides produces a **native, editable** deck — no
  authentication required.
- `references/GSLIDES_SPEC.md` documenting the JSON deck-spec schema and the
  supported slide types, plus `scripts/examples/sample_deck.json` as a worked
  example.

### Changed
- The Google Slides (PPTX) export uses **Roboto** rather than Google Sans. Google
  Sans is proprietary and is not in the Google Slides font library, and Slides
  ignores fonts embedded in a `.pptx` on import, so an editable Slides deck cannot
  render Google Sans; Roboto is Google's own typeface and the closest freely
  available relative. The HTML/PDF export path is unchanged and still uses Google
  Sans.

## [1.0.1] - 2026-06-23

### Added
- PDF export for HTML decks in CLI environments via
  `scripts/html_to_pdf.sh`, which renders a single self-contained HTML deck to a
  multi-page PDF (one slide per page) using system Chrome/Chromium headless, with
  a Playwright fallback.

### Fixed
- Forced a 16:9 height on the cover and thank-you logo slides so the large logo no
  longer pushes those slides off-ratio.
- Prevented PDF page-count doubling caused by on-screen-only slide styles leaking
  into print (documented the `@media print` reset).

## [1.0.0] - 2026-06-12

### Added
- Packaged the Google Cloud slides skill as both a **Claude Code plugin**
  (`.claude-plugin/plugin.json` + a one-plugin `marketplace.json`) and a **Gemini
  CLI extension** (`gemini-extension.json`), sharing a single `skills/` directory.
- The skill itself: `SKILL.md` brand guidelines, the layout catalog
  (`references/LAYOUTS.md`), CSS reference (`references/CSS_SNIPPETS.md`), and the
  bundled brand assets (the multicolour Google Cloud cloud logo and the rainbow
  divider bar).

[Unreleased]: https://github.com/williamtsoi1/google-cloud-slides-skill/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/williamtsoi1/google-cloud-slides-skill/compare/v1.0.1...v1.1.0
[1.0.1]: https://github.com/williamtsoi1/google-cloud-slides-skill/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/williamtsoi1/google-cloud-slides-skill/releases/tag/v1.0.0
