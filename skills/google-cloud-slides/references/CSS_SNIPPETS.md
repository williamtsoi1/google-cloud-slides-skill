# Google Cloud Slides CSS Snippets

Use these CSS snippets when generating slides in `html` mode to match the Google Cloud 2025 visual style.

## Base Styling

```css
/* Base Font and Colors */
:root {
  --gc-blue: #3186FF;
  --gc-red: #FC413D;
  --gc-yellow: #FEC700;
  --gc-green: #00AF57;
  --gc-dark: #202124;
  --gc-light: #FFFFFF;
  --gc-light-blue: #E8F0FE;
}

body {
  font-family: 'Google Sans', 'Product Sans', sans-serif;
  color: var(--gc-dark);
  background-color: var(--gc-light);
}

/* Slide frame — EVERY slide is this fixed 16:9 box, in BOTH the HTML preview
   and the PDF export. The fixed `height` (not `min-height`) is what forces the
   aspect ratio. Without it, a slide sizes itself to its content, so slides with
   a large logo (the cover and the thank-you slide) grow to fit the 400px image
   and render off-ratio (e.g. 1280x640 = 2:1 instead of 16:9). `overflow:hidden`
   clips any accidental overflow instead of letting the slide expand. Apply this
   class to every slide regardless of mode. */
.slide {
  position: relative;
  width: 1280px;
  height: 720px;
  overflow: hidden;
  box-sizing: border-box;
}

/* Cover / Thank-you logo — large but bounded so it can never push the slide
   past its fixed height. */
.cover .logo,
.closing .logo {
  width: 400px;
  height: 400px;
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
  flex-shrink: 0;
}

/* Dark Mode */
.dark-slide {
  background-color: var(--gc-dark);
  color: var(--gc-light);
}
```

## Decorative Elements

```css
/* Rainbow Divider Bar — use the bundled image asset, do NOT recreate with CSS gradients */
.rainbow-bar {
  width: 100%;
  margin-bottom: 20px;
}
.rainbow-bar img {
  width: 100%;
  height: 4px;
  object-fit: fill;
  display: block;
}

/* Footer */
.slide-footer {
  position: absolute;
  bottom: 20px;
  left: 40px;
  right: 40px;
  display: flex;
  justify-content: space-between;
  font-size: 12px;
  color: #5f6368;
}
```

## Typography

```css
/* Headings */
h1 {
  font-size: 64px;
  font-weight: 700;
  margin-bottom: 20px;
}

h2 {
  font-size: 48px;
  font-weight: 500;
}

/* Section Numbers */
.section-number {
  font-size: 80px;
  font-weight: 700;
  color: var(--gc-dark);
}

/* Big Statement Text */
.big-statement {
  font-size: 56px;
  font-weight: 500;
  line-height: 1.2;
}

.big-statement .highlight {
  color: var(--gc-blue);
}

/* Bullets */
ul.gc-bullets {
  list-style-type: disc;
  padding-left: 40px;
}

ul.gc-bullets li {
  font-size: 24px;
  margin-bottom: 16px;
  line-height: 1.4;
}
```

## Print / PDF export

When the deck will be converted to PDF in a CLI environment (see the "Exporting to PDF" section of `SKILL.md`), build it as a **single self-contained HTML file** where every slide is a `.slide` section. The `.slide` rule in **Base Styling** already pins each slide to a fixed 1280x720 (16:9) box — that fixed height is what forces the aspect ratio on the cover and thank-you slides too. Add the page rules below on top of it so Chrome/Playwright render exactly **one slide per PDF page**, with brand backgrounds preserved.

```css
/* 16:9 page at 96dpi. The PDF page size comes from this rule; keep it in sync
   with the fixed .slide dimensions in Base Styling (1280x720). */
@page {
  size: 1280px 720px;
  margin: 0;
}

/* Each slide fills one page and forces a page break after it. (Dimensions and
   overflow come from the .slide rule in Base Styling.) */
.slide {
  page-break-after: always;
  break-after: page;
}

/* Avoid a trailing blank page after the final slide. */
.slide:last-child {
  page-break-after: auto;
  break-after: auto;
}

/* Force backgrounds/colors to print — without this, Chrome drops the green/
   blue/red section backgrounds and the rainbow bar in the PDF. */
body, .slide, .bg-green, .bg-blue, .bg-red, .dark-slide {
  -webkit-print-color-adjust: exact;
  print-color-adjust: exact;
}
```

**Image assets must be absolute.** During printing, Chrome resolves images relative to the HTML file's `file://` location, so reference the bundled brand assets (`templates/gradient_super_cloud_512_2x.png`, `templates/GC_Progress_Bar_Gradient_RGB.jpg`) by their **absolute path** (or copy them next to the deck) — otherwise they will be missing from the PDF.

## Section Dividers

```css
/* Colored Backgrounds */
.bg-green { background-color: var(--gc-green); color: white; }
.bg-blue { background-color: var(--gc-blue); color: white; }
.bg-red { background-color: var(--gc-red); color: white; }

/* Section Divider Layout */
.section-divider {
  display: flex;
  height: 100%;
  padding: 60px;
}

.section-divider .number {
  font-size: 120px;
  font-weight: 700;
  margin-right: 40px;
}

.section-divider .content {
  display: flex;
  flex-direction: column;
  justify-content: center;
}
```
