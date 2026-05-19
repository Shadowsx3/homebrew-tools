# Shadowsx3 Homebrew Tools

Homebrew tap for drop-in `libimobiledevice` tools that can run iPhone commands
over Wi-Fi on macOS when Apple's usbmuxd does not report the paired iPhone as a
network device.

The tap installs:

- `libusbmuxd`: patched `libusbmuxd` with fast Bonjour/Xcode and CoreDevice fallback discovery.
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
xcrun xctrace list devices
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

When an iPhone is connected over USB, this fork does not also expose the same
UDID as a Wi-Fi/network device. Unplug USB to test the Wi-Fi path.

## Connect To An iPhone By Local Wi-Fi IP

If discovery lists the iPhone but commands fail to connect, point
`libusbmuxd` at the phone's classic Wi-Fi lockdown endpoint explicitly.

Get the iPhone UDID from Xcode's device list:

```sh
xcrun xctrace list devices
```

or:

```sh
xcrun devicectl list devices
```

Get the iPhone local IP from the phone itself:

1. Open `Settings` on the iPhone.
2. Open `Wi-Fi`.
3. Tap the info button for the connected Wi-Fi network.
4. Copy the `IP Address` value.

Set the mapping as `<UDID>=<local-ip>`:

```sh
export LIBUSBMUXD_NETWORK_DEVICES="00008150-000629380108401C=192.168.1.20"
```

Persist it for new zsh shells:

```sh
echo 'export LIBUSBMUXD_NETWORK_DEVICES="00008150-000629380108401C=192.168.1.20"' >> ~/.zshrc
```

Then open a new terminal or reload the shell and test:

```sh
source ~/.zshrc
idevice_id -n -l
ideviceinfo -n -u 00008150-000629380108401C -k DeviceName
idevicediagnostics -n -u 00008150-000629380108401C ioregentry AppleSmartBattery
```

Replace the example UDID and IP with the values from your own iPhone.

## Runtime Controls

By default, `libusbmuxd` uses the fast Apple usbmuxd network list when it is
available. If no network device is reported and no explicit fallback is set, it
can discover `_apple-mobdev2._tcp` Bonjour endpoints and match them to paired
Xcode UDIDs by device name before falling back to CoreDevice.

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
