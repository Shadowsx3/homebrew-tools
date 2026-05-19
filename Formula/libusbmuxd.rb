class Libusbmuxd < Formula
  desc "Patched usbmux client library for iPhone Wi-Fi discovery on macOS"
  homepage "https://github.com/Shadowsx3/libusbmuxd"
  url "https://github.com/Shadowsx3/libusbmuxd/releases/download/v2.1.1-wifi.5/libusbmuxd-2.1.1-wifi.5.tar.bz2"
  version "2.1.1-wifi.5"
  sha256 "f5f1838b2c4574fe0fb2f5f95223ccd40e2fc84e4d50a1127788fde472065cde"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/Shadowsx3/libusbmuxd.git", branch: "master"

  bottle do
    root_url "https://github.com/Shadowsx3/homebrew-tools/releases/download/bottles-2026-05-19-v5"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe: "0337e7135e3ebaafcf9520841f25f6d8ed9a29b12754f9e221e6c28adfbc4974"
  end

  depends_on "autoconf" => :build if build.head?
  depends_on "automake" => :build if build.head?
  depends_on "libtool" => :build if build.head?
  depends_on "pkgconf" => :build

  depends_on "libimobiledevice-glue"
  depends_on "libplist"

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      This Shadowsx3/tools formula is a drop-in replacement for Homebrew/core libusbmuxd.
      Install Shadowsx3/tools/libimobiledevice for command-line tools linked to this library.
    EOS
  end

  test do
    assert_match "iproxy", shell_output("#{bin}/iproxy --help")
    assert_match "inetcat", shell_output("#{bin}/inetcat --help")
  end
end
