class Menustats < Formula
  desc "Text-only menu bar monitor for network speed, memory and disk usage"
  homepage "https://github.com/gyane14/menustats"
  url "https://github.com/gyane14/menustats/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "f17e28d51792e3c304269145617e219d8664c00ace0468ed529bde0bd1df5973"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/gyane14/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "845a7948ef06ee44c759a22f558495f1699d27169ac1a6c59997951ef4cbf633"
    sha256 cellar: :any_skip_relocation, sequoia:       "128d4a9a23837fbded49f4f7cf3bbc96995ec91723dd59cee216ba715ecc60ae"
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
    bin.install "uninstall.sh" => "menustats-uninstall"
  end

  service do
    run opt_prefix/"MenuStats.app/Contents/MacOS/MenuStats"
  end

  test do
    assert_match "MEMORY", shell_output("#{bin}/menustats --once")
    assert_predicate bin/"menustats-uninstall", :executable?
  end
end
