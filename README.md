# Google Cloud Slides

A skill that teaches your AI coding agent to generate slide decks in the visual style of
the Google Cloud 2025 presentation template — branded layouts, colors, typography, and
official assets. Ships as both a **Claude Code plugin** and a **Gemini CLI extension** from
the same `skills/` directory.

## What's inside

```
.claude-plugin/plugin.json        Claude Code plugin manifest
.claude-plugin/marketplace.json   One-plugin marketplace (for /plugin install)
gemini-extension.json             Gemini CLI extension manifest
skills/google-cloud-slides/       The shared skill (SKILL.md + references + brand assets)
```

## Install — Claude Code

From a marketplace (recommended):

```
/plugin marketplace add williamtsoi1/google-cloud-slides-skill
/plugin install google-cloud-slides@google-cloud-slides
```

For local development, load the plugin directly without installing:

```
claude --plugin-dir /path/to/google-cloud-slides-skill
```

Validate the plugin and manifests:

```
claude plugin validate .
```

## Install — Gemini CLI

```
gemini extensions install https://github.com/williamtsoi1/google-cloud-slides-skill
```

Alternatively, link it into the extensions directory for local development:

```
ln -s /path/to/google-cloud-slides-skill ~/.gemini/extensions/google-cloud-slides
```

The extension directory name must match the `name` field in `gemini-extension.json`
(`google-cloud-slides`).

## Install — Antigravity CLI

Antigravity CLI consumes this as a **plugin** (its term for Gemini extensions). Install it
directly from GitHub:

```
agy plugin install https://github.com/williamtsoi1/google-cloud-slides-skill
```

If you already have it installed as a Gemini CLI extension, migrate it instead of
reinstalling. Antigravity offers to convert detected Gemini extensions on first launch, or
you can run the import manually:

```
agy plugin import gemini
```

Migration is non-destructive — your original Gemini files are left intact, and the converted
plugin lands under `~/.gemini/antigravity-cli/plugins/`.

## Usage

Once installed, ask your agent to build a Google Cloud–styled deck (e.g. "make a Google
Cloud slide deck about our Q3 results"). The agent loads the `google-cloud-slides` skill and
generates the presentation with the `slides` tool in `html` mode, applying the brand
layouts, palette, and assets.

## Brand rules

See [CLAUDE.md](CLAUDE.md) and [skills/google-cloud-slides/SKILL.md](skills/google-cloud-slides/SKILL.md)
for the full guidelines (color palette, footer requirements, layout catalog, asset usage).
