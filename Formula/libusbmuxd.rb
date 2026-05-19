class Libusbmuxd < Formula
  desc "Patched usbmux client library for iPhone Wi-Fi discovery on macOS"
  homepage "https://github.com/Shadowsx3/libusbmuxd"
  url "https://github.com/Shadowsx3/libusbmuxd/releases/download/v2.1.1-wifi.10/libusbmuxd-2.1.1-wifi.10.tar.bz2"
  version "2.1.1-wifi.10"
  sha256 "80f617bc85d58d524805eb1d4ed1c98880d31dd876f103cdfbc1d84fba4cd471"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/Shadowsx3/libusbmuxd.git", branch: "master"

  bottle do
    root_url "https://github.com/Shadowsx3/homebrew-tools/releases/download/bottles-2026-05-19-v10"
    sha256 cellar: :any, arm64_tahoe: "a5f7587366f3e3839121b4425ca8b27a5fb3899646baf025de98f86740b25101"
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

      Verify your shell uses the tapped tools:
        eval "$(/opt/homebrew/bin/brew shellenv)"
        which ideviceinfo
        otool -L "$(which ideviceinfo)" | grep -E 'libimobiledevice|libusbmuxd'

      If automatic Wi-Fi discovery does not connect to the classic lockdown
      endpoint, set an explicit fallback. Get the UDID from Xcode and the
      local IP from iPhone Settings > Wi-Fi > current network > info:
        xcrun xctrace list devices
        export LIBUSBMUXD_NETWORK_DEVICES="<UDID>=<local-ip>"

      This mapping is authoritative and overrides Apple/CoreDevice network
      records for the same UDID.
    EOS
  end

  test do
    assert_match "iproxy", shell_output("#{bin}/iproxy --help")
    assert_match "inetcat", shell_output("#{bin}/inetcat --help")
  end
end
