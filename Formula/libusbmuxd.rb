class Libusbmuxd < Formula
  desc "Patched usbmux client library for iPhone Wi-Fi discovery on macOS"
  homepage "https://github.com/Shadowsx3/libusbmuxd"
  url "https://github.com/Shadowsx3/libusbmuxd/releases/download/v2.1.1-wifi.9/libusbmuxd-2.1.1-wifi.9.tar.bz2"
  version "2.1.1-wifi.9"
  sha256 "267fdbe7cf021ce6027bfde36d67fc43a7b7399fd575babd84d54e9cd97793be"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/Shadowsx3/libusbmuxd.git", branch: "master"

  bottle do
    root_url "https://github.com/Shadowsx3/homebrew-tools/releases/download/bottles-2026-05-19-v9"
    sha256 cellar: :any, arm64_tahoe: "8204a2bd7c0eb692b8775cf662c328fc6799b6200b3d25fde8e28832fafba3ab"
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
      endpoint, set a Bonjour fallback:
        export LIBUSBMUXD_NETWORK_DEVICES="<UDID>=<iPhone-hostname>.local"
    EOS
  end

  test do
    assert_match "iproxy", shell_output("#{bin}/iproxy --help")
    assert_match "inetcat", shell_output("#{bin}/inetcat --help")
  end
end
