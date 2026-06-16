# Agent Instructions for genzj/homebrew-copyq

This document helps coding agents produce high-quality PRs for this tap.

This is a **personal Homebrew tap** (`genzj/copyq`) hosted at
[github.com/genzj/homebrew-copyq](https://github.com/genzj/homebrew-copyq). It
distributes a small number of casks (currently `copyq`) that are not in, or
differ from, the official [Homebrew Cask](https://github.com/Homebrew/homebrew-cask)
repo. Cask files live under `Casks/`.

Because this is a third-party tap, the strict notability and acceptance rules of
the official repo do not apply—but the cask DSL conventions and local validation
still do.

## Why This Tap Exists

This repo was created to keep distributing [CopyQ](https://github.com/hluk/CopyQ)
via Homebrew on macOS:

- CopyQ used to ship as a cask in the official Homebrew Cask repo.
- That cask is being deprecated because the upstream build does not pass Apple's
  Gatekeeper check (it is not notarized/signed by an Apple-recognized developer
  account).
- Notarization requires an Apple Developer account, and the maintainer's position
  is that developers should not be charged for distributing apps outside the
  Apple App Store. See [hluk/CopyQ#3498](https://github.com/hluk/CopyQ/issues/3498).
- Following the workaround proposed in
  [hluk/CopyQ#2652 (comment)](https://github.com/hluk/CopyQ/issues/2652#issuecomment-4171306975),
  this personal tap was set up so users can keep installing CopyQ through Homebrew.

## Tap Basics

Install the tap and a cask:

```sh
brew tap genzj/copyq https://github.com/genzj/homebrew-copyq
brew install --cask genzj/copyq/copyq
```

Always use the **fully-qualified** token `genzj/copyq/copyq`. A bare `copyq`
token is ambiguous—`copyq` also exists in the official Homebrew Cask repo, so
`brew install --cask copyq` resolves to the core cask, not this tap.

## Before Any PR

1. **Check for existing PRs** for the same cask: [open PRs](https://github.com/genzj/homebrew-copyq/pulls)
2. **Check closed/unmerged PRs** for prior attempts: [closed unmerged PRs](https://github.com/genzj/homebrew-copyq/pulls?q=is%3Apr+is%3Aclosed+is%3Aunmerged)

## Golden Rules

- **One cask per PR**, one intent per PR
- **Minimal diffs**—change only what's necessary
- **No drive-by formatting** or unrelated stanza churn
- **No verbose commentary**—keep PR descriptions short
- **No non-Homebrew caveats** in PR body or cask file
- **Use official sources** for download URLs (e.g. upstream GitHub releases)
- **If unsure about policy** (naming, livecheck), stop and ask before opening a PR

## Version Updates

Because casks in this tap are not on the Homebrew API, edit the file directly:

```sh
brew edit --cask genzj/copyq/<cask>
# Update version, url, sha256 as needed
# Do not add unrelated stanza changes
```

The `brew bump --open-pr` workflow targets the official repo and generally does
not apply to a personal tap.

Commit message: `<cask> <version>` (e.g., `copyq 16.0.0`)

## Cask Fixes

For bug fixes or improvements to existing casks:

```sh
brew edit --cask genzj/copyq/<cask>
# Make only the required changes
```

Commit message: `<cask>: <description>` (e.g., `copyq: fix zap stanza`)

## New Casks

### Creating a New Cask

```sh
brew create --cask --tap genzj/copyq <url>
# Edit the generated cask
```

Commit message: `<cask> <version> (new cask)` (e.g., `myapp 1.0.0 (new cask)`)

### Required Elements

- **Token**: Follow the [token reference](https://docs.brew.sh/Cask-Cookbook#token-reference)—lowercase, hyphens, no version numbers
- **Required stanzas**: `version`, `sha256`, `url`, `name`, `desc`, `homepage`, and at least one artifact (`app`, `pkg`, etc.)
- **`verified:` parameter**: Required when `url` host differs from `homepage` host
- **`uninstall` stanza**: Required for `pkg` and `installer` artifacts
- **`zap` stanza**: Recommended for thorough cleanup (preference files, caches in `~/Library`)

## Required Validation

Run from a checkout of this tap. Set `HOMEBREW_NO_INSTALL_FROM_API=1` so Homebrew
reads the local cask file instead of the API. Always pass the fully-qualified
`genzj/copyq/<cask>` token—a bare token can resolve to the official Homebrew Cask
of the same name instead of this tap.

```sh
export HOMEBREW_NO_INSTALL_FROM_API=1
brew audit --cask --online genzj/copyq/<cask>   # add --new for a brand-new cask
brew style --fix genzj/copyq/<cask>
brew install --cask genzj/copyq/<cask>          # or reinstall
brew uninstall --cask genzj/copyq/<cask>
```

All checks MUST pass locally before opening a PR.

## PR Template Checklist

You MUST verify all items before submitting:

**For all cask changes:**

- [ ] Submission is for a [stable version](https://docs.brew.sh/Acceptable-Casks#stable-versions) or [documented exception](https://docs.brew.sh/Acceptable-Casks#but-there-is-no-stable-version)
- [ ] `brew audit --cask --online genzj/copyq/<cask>` is error-free
- [ ] `brew style --fix genzj/copyq/<cask>` reports no offenses

**Additionally, for new casks:**

- [ ] Named according to [token reference](https://docs.brew.sh/Cask-Cookbook#token-reference)
- [ ] `brew audit --cask --new genzj/copyq/<cask>` worked successfully
- [ ] `HOMEBREW_NO_INSTALL_FROM_API=1 brew install --cask genzj/copyq/<cask>` worked successfully
- [ ] `brew uninstall --cask genzj/copyq/<cask>` worked successfully

**If AI-assisted:**

- [ ] Personally reviewed, tested, and verified all changes including `zap` stanza paths

## Commit Message Format

- Version update: `appname 1.2.3`
- New cask: `appname 1.2.3 (new cask)`
- Fix/change: `appname: <description>`
- First line MUST be 50 characters or less

## PR Hygiene

### MUST

- One cask change per PR
- Keep diffs minimal and focused
- Provide only essential context in PR description

### MUST NOT

- Batch unrelated cask changes
- Include formatting-only diffs
- Add verbose logs or AI analysis in PR body
- Add installation caveats unless the cask DSL requires it
- Include unrelated refactors or stanza reordering

## PR Description

Keep it minimal:

```
Built and tested locally on [macOS version].

[One sentence if not obvious from title.]
```

Do NOT include:

- Large command output or logs
- Lengthy explanations
- Non-Homebrew installation advice

## CI Failures

1. Reproduce failures locally with the same commands
2. Read error messages in "Files changed" tab annotations
3. Fix only the failing issue
4. Push incremental commits (do not squash after opening PR)
5. If stuck, comment describing what you've tried

## AI Disclosure

If AI assisted with the PR, disclose it in the PR description. Briefly describe:

- How AI was used
- What manual verification was performed (especially `zap` paths)

## References

- [Cask Cookbook](https://docs.brew.sh/Cask-Cookbook)
- [Acceptable Casks](https://docs.brew.sh/Acceptable-Casks)
- [Taps](https://docs.brew.sh/Taps)
- [Adding Software to Homebrew](https://docs.brew.sh/Adding-Software-to-Homebrew#casks)
- [How to Open a PR](https://docs.brew.sh/How-To-Open-a-Homebrew-Pull-Request)
