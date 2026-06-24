# Google Slides (PPTX) Deck Spec

`scripts/build_gslides.py` (invoked via `scripts/build_gslides.sh`) turns a JSON deck
spec into a Google Cloud–branded `.pptx`. Upload that `.pptx` to Google Drive and open
it as Google Slides to get a **native, editable** deck — see the "Exporting to Google
Slides" section of `SKILL.md`.

This file is the contract: author the JSON against the schema below.

## Why this path (and its one caveat)

A `.pptx` converted by Drive becomes fully editable Slides — text, shapes, colors, and
the embedded brand images all stay editable. The **only** fidelity compromise is the
font: the deck is built in **Roboto**, not Google Sans. Google Sans is proprietary, is
not in the Google Slides font library, and Slides ignores fonts embedded in a `.pptx` on
import — so an editable deck cannot render real Google Sans. Roboto is Google's own
typeface, is always available in Slides, and is the closest free relative. (The HTML/PDF
export path still uses real Google Sans.)

Brand rules are enforced by the builder, not the spec: every slide gets the footer
("Google Cloud" left, the confidential notice + page number right), section numbers are
zero-padded, and the palette/assets are fixed. You only supply content.

## Top-level shape

```json
{
  "title": "Deck title",
  "footer": "Proprietary & Confidential",
  "slides": [ { "type": "...", ... }, ... ]
}
```

- `title` — string, informational.
- `footer` — optional; the confidential-notice text shown bottom-right before the page
  number. Defaults to `"Proprietary & Confidential"`.
- `slides` — ordered array of slide objects, each keyed by `type`.

## Slide types

| `type` | Required fields | Optional fields |
|---|---|---|
| `cover` | `title` | `subtitle`, `date` |
| `section` | `number`, `title` | `color` (`white`\|`green`\|`blue`\|`red`, default `white`), `items` (only on colored) |
| `title-body` | `title`, `body` | — |
| `two-column` | `title`, `columns` (array of 2 strings) | — |
| `bullets` | `title`, `bullets` (array, 6–8 max, no trailing punctuation) | — |
| `stat` | `stat`, `label` | `support` |
| `three-stat` | `title`, `stats` (array of `{stat, label}`, up to 3) | — |
| `statement` | `text` | `highlight` (leading phrase, rendered blue), `dark` (bool) |
| `two-tone` | `line1`, `line2` (line2 rendered blue) | `dark` (bool) |
| `quote` | `quote` | `attribution` |
| `image-headline` | `image`, `headline` | `side` (`left`\|`right`, default `left`) |
| `bullets-image` | `title`, `bullets`, `image` | — |
| `thank-you` | — | `title` (default `"Thank you"`) |

`image` paths may be absolute or relative to the deck JSON file. Use PNG/JPEG.

An unsupported `type` is a hard error (the builder lists the supported types) — it never
silently emits a blank slide.

## Not yet supported (fast-follow)

Charts (bar/line/pie), tables, maps, agenda/contents grids, icon grids, staircase text,
and the split dark/light and image-column content layouts from `LAYOUTS.md`. For these,
use the HTML/PDF export path for now.

## Example

See `scripts/examples/sample_deck.json` for a complete deck exercising cover, section
dividers, bullets, a stat, a three-stat row, a statement, a two-tone headline, a quote,
and a thank-you slide. Build it with:

```bash
bash scripts/build_gslides.sh scripts/examples/sample_deck.json /tmp/sample.pptx
```
