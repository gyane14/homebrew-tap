class Menustats < Formula
  desc "Text-only menu bar monitor for network speed, memory and disk usage"
  homepage "https://github.com/gyane14/menustats"
  url "https://github.com/gyane14/menustats/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "946dfec32f1a6f9698edf5bb3dccf90c38c05beb3269d5b1a97fdc13191b9d4f"
  license "GPL-3.0-only"

  bottle do
    root_url "https://github.com/gyane14/homebrew-tap/releases/download/menustats-0.1.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da4f28cf2354639f25c1251f3a014572abeaf56068fd72f897c36fa7a723bbe0"
    sha256 cellar: :any_skip_relocation, sequoia:       "9ad445952344aba0beb5d815d050ce87467aea256c92e1c0b387e2df921264d3"
  end

  depends_on macos: :ventura

  def install
    contents = prefix/"MenuStats.app/Contents"
    (contents/"MacOS").mkpath
    # target the app's minimum macOS (Info.plist), not the build machine's, so bottles run on older systems
    system "swiftc", "-O", "-target", "#{Hardware::CPU.arch}-apple-macos13.0",
           "main.swift", "-o", contents/"MacOS/MenuStats"
    contents.install "Info.plist"
    bin.install_symlink contents/"MacOS/MenuStats" => "menustats"
  end

  service do
    run opt_prefix/"MenuStats.app/Contents/MacOS/MenuStats"
  end

  test do
    assert_match "MEMORY", shell_output("#{bin}/menustats --once")
  end
end
