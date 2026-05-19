class Libimobiledevice < Formula
  desc "Tools linked to patched iPhone Wi-Fi discovery support"
  homepage "https://github.com/libimobiledevice/libimobiledevice"
  url "https://github.com/libimobiledevice/libimobiledevice/releases/download/1.4.0/libimobiledevice-1.4.0.tar.bz2"
  sha256 "23cc0077e221c7d991bd0eb02150a0d49199bcca1ddf059edccee9ffd914939d"
  license "LGPL-2.1-or-later"
  revision 3
  head "https://github.com/libimobiledevice/libimobiledevice.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "libimobiledevice-glue"
  depends_on "libplist"
  depends_on "libtasn1"
  depends_on "libtatsu"
  depends_on "openssl@3"
  depends_on "shadowsx3/tools/libusbmuxd"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["shadowsx3/tools/libusbmuxd"].opt_lib/"pkgconfig"
    ENV.prepend "CPPFLAGS", "-I#{Formula["shadowsx3/tools/libusbmuxd"].opt_include}"
    ENV.prepend "LDFLAGS", "-L#{Formula["shadowsx3/tools/libusbmuxd"].opt_lib}"

    args = %w[
      --disable-silent-rules
      --without-cython
      --enable-debug
    ]

    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *args, *std_configure_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      This Shadowsx3/tools formula is a drop-in replacement for Homebrew/core libimobiledevice.

      For iPhone Wi-Fi command discovery, use the full Xcode app and select it:
        sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

      In Finder, connect the iPhone over USB, select it under Locations, enable
      "Show this iPhone when on Wi-Fi", then click Apply.

      Then verify:
        idevice_id -n -l
        ideviceinfo -n -u <UDID> -k DeviceName

      Disable the CoreDevice fallback for one command with:
        LIBUSBMUXD_COREDEVICE_AUTODISCOVERY=0 idevice_id -n -l
    EOS
  end

  test do
    system bin/"idevice_id", "--version"
    if OS.mac?
      assert_match Formula["shadowsx3/tools/libusbmuxd"].opt_lib.to_s,
                   shell_output("otool -L #{bin}/idevice_id")
    end
  end
end
