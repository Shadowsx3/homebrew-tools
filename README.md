# Shadowsx3 Homebrew Tools

Homebrew tap for drop-in `libimobiledevice` tools that can run iPhone commands
over Wi-Fi on macOS when Apple's usbmuxd does not report the paired iPhone as a
network device.

The tap installs:

- `libusbmuxd`: patched `libusbmuxd` with Xcode/CoreDevice fallback discovery.
- `libimobiledevice`: `libimobiledevice` command-line tools linked against the patched `libusbmuxd`.

## Install

### Enable iPhone Wi-Fi Access In Finder

1. Connect the iPhone to the Mac with USB.
2. Open Finder and select the iPhone under `Locations` in the sidebar.
3. If prompted, click `Trust` in Finder and tap `Trust This Computer` on the iPhone.
4. In the `General` tab, enable `Show this iPhone when on Wi-Fi`.
5. Click `Apply`.
6. Keep the iPhone and Mac on the same Wi-Fi network.

If the iPhone does not appear in Finder, open `Finder > Settings > Sidebar` and
enable `CDs, DVDs, and iOS Devices`.

### Install Xcode/CoreDevice

Install the full Xcode app first. The Wi-Fi fallback uses `xcrun devicectl`,
which is provided by Xcode/CoreDevice.

```sh
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
xcrun devicectl list devices
```

Install the tap and tools:

```sh
brew tap Shadowsx3/tools
brew install Shadowsx3/tools/libimobiledevice
```

This installs the patched formulas as drop-in replacements for Homebrew/core's
`libusbmuxd` and `libimobiledevice`.
On supported Apple Silicon macOS versions, Homebrew pours prebuilt bottles from
this tap's GitHub releases. To force a local source build, add
`--build-from-source`.

If Homebrew already has the stock formulas installed and reports a conflict,
replace them explicitly:

```sh
brew uninstall libimobiledevice libusbmuxd
brew install Shadowsx3/tools/libimobiledevice
```

Verify:

```sh
which idevice_id
idevice_id -n -l
ideviceinfo -n -u <UDID> -k DeviceName
idevicediagnostics -n -u <UDID> diagnostics GasGauge
```

## Runtime Controls

Disable CoreDevice fallback discovery for one command:

```sh
LIBUSBMUXD_COREDEVICE_AUTODISCOVERY=0 idevice_id -n -l
```

Force CoreDevice fallback discovery even when usbmuxd already reports network
devices:

```sh
LIBUSBMUXD_COREDEVICE_AUTODISCOVERY=force idevice_id -n -l
```

## Source

- Patched fork: https://github.com/Shadowsx3/libusbmuxd
- Upstream project: https://github.com/libimobiledevice
