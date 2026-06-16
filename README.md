# homebrew-copyq

A personal [Homebrew](https://brew.sh) tap (`genzj/copyq`) that distributes
[CopyQ](https://github.com/hluk/CopyQ), an advanced clipboard manager, for macOS.

## Why this tap exists

CopyQ used to ship as a cask in the official Homebrew Cask repo, but that cask is
being deprecated because the upstream build does not pass Apple's Gatekeeper check
(it is not notarized). Notarization requires a paid Apple Developer account, and
the maintainer's position is that developers should not be charged to distribute
apps outside the App Store (see [hluk/CopyQ#3498](https://github.com/hluk/CopyQ/issues/3498)).

Following the workaround in
[hluk/CopyQ#2652 (comment)](https://github.com/hluk/CopyQ/issues/2652#issuecomment-4171306975),
this tap re-signs the app ad-hoc on install so you can keep installing CopyQ
through Homebrew.

## Install

```sh
brew tap genzj/copyq https://github.com/genzj/homebrew-copyq
brew install --cask genzj/copyq/copyq
```

Always use the fully-qualified token `genzj/copyq/copyq`. A bare `copyq` resolves
to the (deprecated) cask in the official Homebrew Cask repo, not this tap.

The install runs a `postflight` that removes the quarantine flag, ad-hoc re-signs
the bundle, links the `copyq` CLI into your Homebrew prefix, and resets the
Accessibility permission entry. The symlink and permission reset require `sudo`,
so you may be prompted for your password during install.

## Uninstall

```sh
brew uninstall --cask genzj/copyq/copyq
brew untap genzj/copyq
```

## Contributing

See [AGENTS.md](AGENTS.md) for cask conventions, validation steps, and PR
guidelines.
