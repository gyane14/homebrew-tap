class Menustats < Formula
  desc "Text-only menu bar monitor for network speed, memory and disk usage"
  homepage "https://github.com/gyane14/menustats"
  url "https://github.com/gyane14/menustats/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "946dfec32f1a6f9698edf5bb3dccf90c38c05beb3269d5b1a97fdc13191b9d4f"
  license "GPL-3.0-only"

  depends_on macos: :ventura

  def install
    contents = prefix/"MenuStats.app/Contents"
    (contents/"MacOS").mkpath
    system "swiftc", "-O", "main.swift", "-o", contents/"MacOS/MenuStats"
    contents.install "Info.plist"
    bin.install_symlink contents/"MacOS/MenuStats" => "menustats"
  end

  service do
    run opt_prefix/"MenuStats.app/Contents/MacOS/MenuStats"
  end

  def caveats
    <<~EOS
      Start MenuStats now and at every login:
        brew services start menustats
    EOS
  end

  test do
    assert_match "MEMORY", shell_output("#{bin}/menustats --once")
  end
end
