cask "copyq" do
  arch arm: "12-m1", intel: "13"

  version "16.0.0"
  sha256 arm:   "57563fb2ca24751974c35b744ca7ea2c5c171bc5c00f59b3c8379912876ae4b1",
         intel: "817a35cc5e143207496d78ccc0d8dd62a9858fece8099d1f4591d00b24dbca27"

  on_arm do
    depends_on macos: :monterey
  end
  on_intel do
    depends_on macos: :ventura
  end

  url "https://github.com/hluk/CopyQ/releases/download/v#{version}/CopyQ-#{version}-macos-#{arch}.dmg",
      verified: "github.com/hluk/CopyQ/"
  name "CopyQ"
  desc "Clipboard manager with advanced features"
  homepage "https://hluk.github.io/CopyQ/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on :macos

  app "CopyQ.app"

  # The upstream build is not notarized and fails Gatekeeper. Reset the
  # quarantine flag, ad-hoc re-sign, refresh the CLI symlink, and clear the
  # stale Accessibility entry so macOS treats the new bundle as a fresh app.
  # https://github.com/hluk/CopyQ/issues/2652
  postflight do
    system_command "/usr/bin/xattr",
                   args:         ["-d", "com.apple.quarantine", "#{appdir}/CopyQ.app"],
                   must_succeed: false

    system_command "/usr/bin/codesign",
                   args: ["--force", "--deep", "--sign", "-", "#{appdir}/CopyQ.app"]

    system_command "/bin/ln",
                   args: ["-sf", "#{appdir}/CopyQ.app/Contents/MacOS/CopyQ", "#{HOMEBREW_PREFIX}/bin/copyq"],
                   sudo: true

    system_command "/usr/bin/tccutil",
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