---
name: google-cloud-slides
description: "Create slide decks with the visual style of the Google Cloud 2025 presentation template. Use for: generating professional, branded presentations with specific Google Cloud layouts, colors, and typography."
---

# Google Cloud Slides Skill

This skill provides instructions and assets for creating slide decks that match the visual style of the Google Cloud 2025 presentation template.

## Core Visual Style

When creating slides using this skill, always adhere to the following brand guidelines:

- **Brand name**: Google Cloud
- **Footer**: Every slide must include "Google Cloud" in the bottom-left corner and "Proprietary & Confidential  [page#]" in the bottom-right corner.
- **Font**: Use Google Sans (or a clean, rounded, modern sans-serif fallback like Product Sans).
- **Primary text color**: Near-black (`#202124`).

### Color Palette

| Role | Hex Code | Usage |
|---|---|---|
| Background (light) | `#FFFFFF` | Default slide background |
| Background (dark) | `#202124` | Dark-mode slides |
| Text (light bg) | `#202124` | Body and headings |
| Text (dark bg) | `#FFFFFF` | Body and headings on dark backgrounds |
| Google Blue | `#4285F4` | Accent, section dividers, chart fills, highlighted text |
| Google Red | `#EA4335` | Accent, section dividers |
| Google Yellow/Gold | `#FBBC04` | Accent, section dividers |
| Google Green | `#34A853` | Accent, section dividers |

### Key Decorative Elements

1. **Rainbow divider bar**: A thin horizontal line graduating Red → Blue → Green → Yellow. Used as a section separator, sometimes partial-width (left-aligned or right-aligned).
2. **Google Cloud "C" arc**: Large overlapping arcs (Red, Blue, Yellow) forming the Google Cloud logo "C" shape. Used on cover and thank-you slides.
3. **Colored section backgrounds**: Full-bleed solid backgrounds in Google Green (`#34A853`), Google Blue (`#4285F4`), or Google Red (`#EA4335`) for section dividers.

## Slide Layouts

The template supports a variety of layouts. When generating content, select the appropriate layout type from the catalog below.

For detailed descriptions of all available layouts, see [LAYOUTS.md](references/LAYOUTS.md).

### Common Layouts

- **Cover / Title**: Large bold headline left, date below, Google Cloud logo bottom-left, "C" arc decoration right.
- **Section divider**: Rainbow bar top, large section number (zero-padded, e.g., "01") + title.
- **Title + body (1-col)**: Slide title top-left, body text below.
- **2-column text**: Slide title, two equal text columns.
- **Stat / Big number**: Large bold stat (e.g., "40%") in Google Blue, label below, supporting text.
- **Bullets**: Title + bullet list (6–8 items max, no punctuation).
- **Big statement**: Full-slide large text, first phrase in Google Blue, rest in dark.

## Typography Rules

- **Bullets**: Keep them clear and punchy. Use single lines when possible. Maximum 6–8 items per slide. Do not use punctuation at the end of bullet points.
- **Images**: Images should help "do the heavy lifting." Keep copy concise and aligned with the image.
- **Section numbers**: Always use zero-padded 2-digit numbers (01, 02, 03, etc.).
- **Chart subtitles**: Use UPPERCASE text in Google Blue.

## Usage Instructions

1. **Understand the Content**: Review the content to be presented and determine the best layout for each slide.
2. **Select Layouts**: Refer to [LAYOUTS.md](references/LAYOUTS.md) to choose the appropriate layout structure.
3. **Apply Styling**: Ensure all colors, fonts, and decorative elements match the guidelines above.
4. **Generate Slides**: Use the `slides` tool in `html` mode to generate the presentation, applying the necessary CSS to match the Google Cloud style.

### Example CSS Snippets

For reference on how to implement the visual style in HTML/CSS, see [CSS_SNIPPETS.md](references/CSS_SNIPPETS.md).
