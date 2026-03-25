# Google Cloud Slides CSS Snippets

Use these CSS snippets when generating slides in `html` mode to match the Google Cloud 2025 visual style.

## Base Styling

```css
/* Base Font and Colors */
:root {
  --gc-blue: #4285F4;
  --gc-red: #EA4335;
  --gc-yellow: #FBBC04;
  --gc-green: #34A853;
  --gc-dark: #202124;
  --gc-light: #FFFFFF;
  --gc-light-blue: #E8F0FE;
}

body {
  font-family: 'Google Sans', 'Product Sans', sans-serif;
  color: var(--gc-dark);
  background-color: var(--gc-light);
}

/* Dark Mode */
.dark-slide {
  background-color: var(--gc-dark);
  color: var(--gc-light);
}
```

## Decorative Elements

```css
/* Rainbow Divider Bar */
.rainbow-bar {
  height: 4px;
  width: 100%;
  background: linear-gradient(to right, var(--gc-red), var(--gc-blue), var(--gc-green), var(--gc-yellow));
  margin-bottom: 20px;
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
