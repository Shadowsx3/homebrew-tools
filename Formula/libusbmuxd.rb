class Libusbmuxd < Formula
  desc "Patched usbmux client library for iPhone Wi-Fi discovery on macOS"
  homepage "https://github.com/Shadowsx3/libusbmuxd"
  url "https://github.com/Shadowsx3/libusbmuxd/releases/download/v2.1.1-wifi.11/libusbmuxd-2.1.1-wifi.11.tar.bz2"
  version "2.1.1-wifi.11"
  sha256 "25b74869439cec91ad4ca9d541d7958735d4b1a3e0d8de61548ebca388e7ff45"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/Shadowsx3/libusbmuxd.git", branch: "master"

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
      records for the same UDID. When it is not set, this build can discover
      local iPhone endpoints through Bonjour and match them to Xcode UDIDs.
    EOS
  end

  test do
    assert_match "iproxy", shell_output("#{bin}/iproxy --help")
    assert_match "inetcat", shell_output("#{bin}/inetcat --help")
  end
end
