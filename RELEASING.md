# Releasing

This is the maintainer checklist for cutting a release. It is the **canonical**
description of the process — `CLAUDE.md` and `README.md` point here rather than
repeating it.

## Versioning

This project follows [Semantic Versioning](https://semver.org/):

- **MAJOR** (`2.0.0`) — breaking changes (e.g. removing a slide layout type, changing
  the deck-spec schema incompatibly).
- **MINOR** (`1.1.0`) — new backward-compatible features (e.g. a new export path or
  layout).
- **PATCH** (`1.0.1`) — backward-compatible fixes and docs.

The version is stored **by hand in two files that must always match**:

- `.claude-plugin/plugin.json` → `version`
- `gemini-extension.json` → `version`

`.claude-plugin/marketplace.json` carries no version. Keep the three `description`
fields (`plugin.json`, `marketplace.json`, and `SKILL.md` frontmatter) consistent too.

## Release checklist

1. **Update `CHANGELOG.md`.** Move the items under `## [Unreleased]` into a new
   `## [X.Y.Z] - YYYY-MM-DD` section (ISO date), grouped under the Keep a Changelog
   headings (Added / Changed / Deprecated / Removed / Fixed / Security). Leave a fresh,
   empty `## [Unreleased]` at the top. Add a compare link for the new version at the
   bottom of the file (and update the `[Unreleased]` link to point at the new tag).

2. **Bump the version** in both manifests (`.claude-plugin/plugin.json` and
   `gemini-extension.json`) to `X.Y.Z`.

3. **Validate** the manifests:
   ```bash
   claude plugin validate .
   ```

4. **Commit** the changelog + version bump:
   ```bash
   git commit -am "release X.Y.Z"
   ```

5. **Tag and push.** The tag **must** be `vX.Y.Z` — the release workflow keys off it,
   and pulls the matching `## [X.Y.Z]` section from `CHANGELOG.md` as the release notes:
   ```bash
   git tag -a vX.Y.Z -m "Release X.Y.Z — <one-line summary>"
   git push origin main --follow-tags
   ```

6. **Done — the rest is automated.** `.github/workflows/release.yml` triggers on the
   pushed `v*` tag and creates the GitHub Release from the changelog section (falling
   back to GitHub's auto-generated notes if no matching section is found). Confirm it on
   the [Releases page](https://github.com/williamtsoi1/google-cloud-slides-skill/releases);
   the newest semver tag is flagged **Latest** automatically.

## How the automated release works

`.github/workflows/release.yml`:

- Triggers on any pushed tag matching `v*`.
- Extracts the lines under `## [<version>]` (version = tag without the `v`) from
  `CHANGELOG.md` and uses them as the release body.
- Falls back to `gh release create --generate-notes` if that section is empty/missing.
- Uses the built-in `GITHUB_TOKEN` (`permissions: contents: write`) — no secrets to
  configure.

This means the changelog is the single source of truth for release notes: if the
`## [X.Y.Z]` heading or its date format is wrong, the notes will be empty and the
workflow will fall back to commit-based notes.

## Creating a release manually (fallback)

If you ever need to (re)create a release outside the workflow — e.g. backfilling an old
tag — use the `gh` CLI (requires `gh auth login` once):

```bash
gh release create vX.Y.Z --verify-tag --title "vX.Y.Z — <summary>" --notes-file notes.md
# add --latest=false when backfilling a version older than the current latest
```
