class LibusbmuxdWifi < Formula
  desc "Patched usbmux client library for iPhone Wi-Fi discovery on macOS"
  homepage "https://github.com/Shadowsx3/libusbmuxd"
  url "https://github.com/Shadowsx3/libusbmuxd/archive/refs/tags/v2.1.1-wifi.1.tar.gz"
  version "2.1.1-wifi.1"
  sha256 "8a14a2e8ca4299a6f18abc6b85423835717e035921063c7797d598e7d44e0fef"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/Shadowsx3/libusbmuxd.git", branch: "master"

  keg_only "it installs libusbmuxd files that conflict with Homebrew's stock libusbmuxd"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "libimobiledevice-glue"
  depends_on "libplist"

  def install
    (buildpath/".tarball-version").write version
    system "./autogen.sh", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      This formula is keg-only because it conflicts with Homebrew's stock libusbmuxd.
      Install Shadowsx3/tools/libimobiledevice-wifi for command-line tools linked to this library.
    EOS
  end

  test do
    assert_match "iproxy", shell_output("#{bin}/iproxy --help")
    assert_match "inetcat", shell_output("#{bin}/inetcat --help")
  end
end
