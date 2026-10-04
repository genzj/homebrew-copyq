cask "copyq" do
  arch arm: "13-m1", intel: "13"

  version "17.0.0"
  sha256 arm:   "d14ceb215821be1d127a4153f27b914b41d542749d92beb21e9446896db89346",
         intel: "ab5b10a799741fd6c750ba5ef8dd9c6d8ff8804ff8d93a68d3facf3150f0a6b8"

  url "https://github.com/hluk/CopyQ/releases/download/v#{version}/CopyQ-#{version}-macos-#{arch}.dmg"
  name "CopyQ"
  desc "Clipboard manager with advanced features"
  homepage "https://hluk.github.io/CopyQ/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "CopyQ.app"

  # The upstream build is not notarized and fails Gatekeeper. Reset the
  # quarantine flag, ad-hoc re-sign, refresh the CLI symlink, and clear the
  # stale Accessibility entry so macOS treats the new bundle as a fresh app.
  # https://github.com/hluk/CopyQ/issues/2652
  postflight_steps do
    run "/usr/bin/xattr",
        args:         ["-d", "com.apple.quarantine", "{{appdir}}/CopyQ.app"],
        must_succeed: false

    run "/usr/bin/codesign",
        args: ["--force", "--deep", "--sign", "-", "{{appdir}}/CopyQ.app"]

    run "/bin/ln",
        args: ["-sf", "{{appdir}}/CopyQ.app/Contents/MacOS/CopyQ", "{{HOMEBREW_PREFIX}}/bin/copyq"],
        sudo: true

    run "/usr/bin/tccutil",
        args:         ["reset", "Accessibility", "io.github.hluk.CopyQ"],
        sudo:         true,
        must_succeed: false
  end

  zap trash: [
    "~/.config/copyq",
    "~/Library/Application Support/copyq",
    "~/Library/Application Support/copyq.log",
    "~/Library/Preferences/com.copyq.copyq.plist",
  ]

  caveats do
    unsigned_accessibility
  end
end
