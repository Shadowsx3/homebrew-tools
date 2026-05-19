# Shadowsx3 Homebrew Tools

Homebrew tap for `libimobiledevice` tools that can run iPhone commands over
Wi-Fi on macOS when Apple's usbmuxd does not report the paired iPhone as a
network device.

The tap installs:

- `libusbmuxd-wifi`: patched `libusbmuxd` with Xcode/CoreDevice fallback discovery.
- `libimobiledevice-wifi`: `libimobiledevice` command-line tools linked against `libusbmuxd-wifi`.

## Install

Install the full Xcode app first. The Wi-Fi fallback uses `xcrun devicectl`,
which is provided by Xcode/CoreDevice.

```sh
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
xcrun devicectl list devices
```

Install the tap and tools:

```sh
brew tap Shadowsx3/tools
brew install libimobiledevice-wifi
```

The formulas are keg-only to avoid overwriting Homebrew's stock
`libusbmuxd` and `libimobiledevice`. Add the Wi-Fi-enabled tools to your shell:

```sh
echo 'export PATH="$(brew --prefix libimobiledevice-wifi)/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
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
