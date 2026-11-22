# NixOS configuration

Configurations for the `utm-on-mac14` ARM64 UTM virtual machine and the
`g14` x86_64 laptop. Both share packages and desktop settings in
`modules/common.nix`; hardware, hostnames and display settings live under
`hosts/<host>/`.

## Apply

After adding the configuration files to Git, create and commit the lock file so
every rebuild uses the same Nixpkgs revision:

```sh
git add flake.nix hosts
./create-lock-utm-on-mac14.sh
git add flake.lock
```

Build the configuration without activating it:

```sh
./build-utm-on-mac14.sh
```

Apply the configuration:

```sh
./apply-utm-on-mac14.sh
```

## Neovim

The managed Neovim installation loads `config/nvim/init.lua`, followed by the
current user's `~/.config/nvim/init.lua` or `init.vim` when present. Apply
changes to the managed example with:

```sh
./apply-utm-on-mac14.sh
```

It prints `Hello world` when Neovim starts.

## Codex

The system includes both the Codex CLI and the Linux desktop app for the
selected host architecture. Run
`codex` in a terminal, or launch **ChatGPT Community** from Fuzzel. The desktop
package uses OpenAI's signed Linux application payload.

## Browsers and independent updates

Both hosts include Chromium (the open-source browser, not Google Chrome) and
LibreWolf. Launch them from Fuzzel or run `chromium` / `librewolf` in a terminal.
Firefox remains available.

Each browser uses its own Nixpkgs input pinned in `flake.lock`:

| Browser | Input | Update command |
| --- | --- | --- |
| Chromium | `chromium-nixpkgs` | `nix flake update chromium-nixpkgs` |
| LibreWolf | `librewolf-nixpkgs` | `nix flake update librewolf-nixpkgs` |

These inputs track `nixos-26.05`. Updating one selects the browser version
available on that branch and its dependencies, while leaving the other browser,
the main `nixpkgs` input and the Codex desktop input pinned. A branch update does
not necessarily contain a new browser version. Do not add `follows = "nixpkgs"`
to these inputs, since that would tie their updates to the system again.

For example, update only Chromium, review the lock change, build and apply on
the G14:

```sh
nix flake update chromium-nixpkgs
git diff -- flake.lock
./build-g14.sh
./apply-g14.sh
git add flake.lock
git commit -m "Update Chromium package pin"
```

For LibreWolf, use `nix flake update librewolf-nixpkgs` instead. To update both
browsers together without updating other inputs:

```sh
nix flake update chromium-nixpkgs librewolf-nixpkgs
```

On the Mac VM, use `./build-utm-on-mac14.sh` and `./apply-utm-on-mac14.sh`.
The pins are shared by both hosts; rebuild each host to use the updated browsers.
The existing `update-lock-*.sh` scripts update all inputs and apply the system,
so use the targeted commands above for browser-only updates. Nix documents
[selective input updates](https://nix.dev/manual/nix/latest/command-ref/new-cli/nix3-flake-update).

## Rider

Both hosts install Rider 2026.3.0.1 using `packages/rider.nix`. This pins the
official JetBrains Linux downloads and checksums independently of the system
Nixpkgs revision while retaining Nixpkgs' Rider packaging and runtime setup.
The optional native Microsoft authentication broker is unavailable: it requires
WebKitGTK 4.0, which this Nixpkgs pin no longer provides. Authentication flows
that require that broker are not supported by this package.
To update Rider, change its version, build number and both architecture hashes
in that file using the
[JetBrains release API](https://data.services.jetbrains.com/products/releases?code=RD&latest=true&type=release).
Add the package file to Git before rebuilding the flake:

```sh
git add packages/rider.nix modules/common.nix README.md
./build-g14.sh
./apply-g14.sh rider-update
```

## Video player and file manager

Both hosts include mpv for video playback and Nautilus (Files) as the graphical
file manager. Open Files with `Super+E` or launch `nautilus` from a terminal.
GVfs provides support for trash, removable drives and network locations.

To play a video:

```sh
mpv /path/to/video.mp4
```

In mpv, Space toggles pause, Left/Right seek, `f` toggles fullscreen and `q`
quits. The player also provides mouse controls over the video.

The G14 also includes Jellyfin Desktop (`pkgs.jellyfin-desktop`). Launch
Jellyfin Desktop from Fuzzel and enter your Jellyfin server address to connect.

## Hyprland

Shared Hyprland settings are managed in `config/hypr/hyprland.lua`. Display
settings specific to this virtual machine live in
`hosts/utm-on-mac14/hyprland.lua`. Nix combines both into the managed
`~/.config/hypr/hyprland.lua`. After applying the system configuration, log out
and select **Hyprland** from GDM's session menu.

See [Shortcuts](#shortcuts) for all configured bindings. Their source is
`config/hypr/hyprland.lua`; the G14 spelling shortcut is managed in
`hosts/g14/hyprland.lua`.

Both G14 and UTM-on-Mac14 use Apple-style natural scrolling for mouse wheels
and touchpads.

Mako has no other notification keyboard shortcuts configured. To dismiss all
notifications from a terminal, run `makoctl dismiss --all`.

Waybar starts hidden and overlays windows when shown, so it reserves no screen
space and toggling it does not resize windows. Both hosts use the shared settings
in `config/waybar/config.jsonc` and `config/waybar/style.css`. The bar displays
workspaces, the date/time, CPU and memory usage, network status, volume, battery
status (where available), and a system tray. Clicking the volume toggles mute.
Battery colours indicate low charge; they do not send notifications.

After changing the configuration, rebuild and start a new Hyprland session.
Add new files under `config/waybar/` to Git before rebuilding with the flake.

To label the generated boot entry:

```sh
sudo nixos-rebuild switch --flake .#utm-on-mac14 --impure
```

with `NIXOS_LABEL` set in the root environment, for example:

```sh
sudo NIXOS_LABEL=utm-sharing nixos-rebuild switch --flake .#utm-on-mac14 --impure
```

## Shortcuts

`Super` means the Windows key. `Hyper` means holding `Ctrl+Shift+Alt+Super`
together; no dedicated Hyper key is configured. Letter keys below do not need
Shift unless it is explicitly listed. Hyprland shortcuts apply to both hosts;
Spelling suggestions, HyprEmoji and the keyd mappings apply only to the G14.

### Applications and session

| Shortcut | Action |
| --- | --- |
| `Super+Return` | Open Kitty |
| `Super+D` | Open Fuzzel, the application launcher |
| `Super+S` | Fuzzy switch to an open app/window |
| `Super+E` | Open Files |
| `Super+Shift+E` | Exit Hyprland |
| `Hyper+.` | Open HyprEmoji (G14 only) |

Jellyfin Desktop is installed on the G14 and can be launched through Fuzzel
with `Super+D`. No dedicated Jellyfin shortcut is configured.

iwmenu is installed on the G14 as **Wi-Fi Networks** in Fuzzel (`Super+D`).
No dedicated Wi-Fi shortcut is configured, so the available shortcuts below
are unchanged.

### Windows and layout

| Shortcut | Action |
| --- | --- |
| `Super+Q` | Close the active window |
| `Super+O` | Focus the previously selected window |
| `Super+F` | Toggle fullscreen |
| `Super+V` | Toggle floating mode |
| `Super+P` | Toggle pseudotiling |
| `Super+Shift+J` | Toggle the active dwindle split direction |
| `Super` + left-button drag | Move a window |
| `Super` + right-button drag | Resize a window |

### Focus and workspaces

| Shortcut | Action |
| --- | --- |
| `Super+Left` or `Super+H` | Focus the window to the left |
| `Super+Down` or `Super+J` | Focus the window below |
| `Super+Up` or `Super+K` | Focus the window above |
| `Super+Right` or `Super+L` | Focus the window to the right |
| `Super+1` through `Super+9` | Switch to workspace 1 through 9 |
| `Super+0` | Switch to workspace 10 |
| `Super+F1` through `Super+F9` | Move the active window to workspace 1 through 9 |
| `Super+F10` | Move the active window to workspace 10 |
| `Super+Tab` | Next existing workspace |
| `Super+Shift+Tab` | Previous existing workspace |

### Bar and notifications

| Shortcut | Action |
| --- | --- |
| `Super+B` | Show/hide Waybar; it starts hidden and reserves no space |
| `Super+X` | Dismiss the latest Mako notification |

### Screenshots

| Shortcut | Action |
| --- | --- |
| `Print` | Select an area and copy its screenshot to the clipboard |
| `Super+Print` | Copy all outputs as one screenshot to the clipboard |

Screenshots are not saved to files.

### Hardware keys

These require no Super modifier and also work while the session is locked.

| Shortcut | Action |
| --- | --- |
| `XF86AudioRaiseVolume` | Raise volume by 5%, capped at 100%; repeats on hold |
| `XF86AudioLowerVolume` | Lower volume by 5%; repeats on hold |
| `XF86AudioMute` | Toggle output mute |
| `XF86AudioPlay` | Toggle media play/pause |
| `XF86AudioNext` | Next media track |
| `XF86AudioPrev` | Previous media track |
| `XF86MonBrightnessUp` | Raise display brightness by 5%; repeats on hold |
| `XF86MonBrightnessDown` | Lower display brightness by 5%; repeats on hold |

### Spelling suggestions (G14)

| Shortcut | Action |
| --- | --- |
| `Super+C` (correct) | Copy the selected word and show Aspell `en_GB` spelling suggestions in Rofi |

Select a single word, press and release `Super+C`, choose a suggestion, then
paste it over the selected word. The command sends `Ctrl+C` to the focused app
(`Ctrl+Shift+C` in supported terminals, including Kitty) and waits for a fresh
clipboard update before opening Rofi. Apps with custom copy shortcuts may not
work. Escape leaves the copied selection on the clipboard without applying a
suggestion. No automatic pasting or background keyboard monitoring is used.
After applying the configuration, run `hyprctl reload` or start a new Hyprland
session to activate the binding.

### Available Super shortcuts

These Windows-key combinations were checked against the repository and all
56 bindings in the running G14 Hyprland session on 2026-11-22:

| Shortcuts | Status |
| --- | --- |
| `Super+A`, `Super+G`, `Super+I`, `Super+M` | Unassigned |
| `Super+N`, `Super+R`, `Super+T`, `Super+U` | Unassigned |
| `Super+W`, `Super+Y`, `Super+Z` | Unassigned |

The other Super+A-Z combinations are assigned. In particular, `Super+C` runs
spelling suggestions, `Super+S` switches windows and `Super+X` dismisses the
latest notification. For Super+Shift+A-Z, only `Super+Shift+E` (exit Hyprland)
and `Super+Shift+J` (toggle split direction) are assigned; the other letters
are unassigned.

Hyper (`Ctrl+Shift+Alt+Super`) is a different modifier combination. Hyprland
uses `Hyper+.` for HyprEmoji on the G14 and has no configured A-Z Hyper
bindings. However, keyd's `Ctrl+M` to Return mapping
means `Hyper+M` should not be treated as an available literal M chord.
The availability table above is specifically for Super (the Windows key).
Individual applications can define additional keys; this audit covers
compositor bindings and the checked-in keyd mappings.

### Caps Lock and Control (G14)

These system-wide keyd mappings also work outside Hyprland.

| Shortcut | Action |
| --- | --- |
| Tap Caps Lock alone | Escape |
| Hold Caps Lock with another key | Control + that key |
| `Ctrl+M` or `Caps Lock+M` | Return; overrides Control+M |

## G14

### Aspell and Rofi

The G14 installs Aspell with the English dictionaries, Rofi with Wayland support,
and the `spelling-suggestions` command using `modules/spelling.nix`.
The dictionary is British English (`en_GB`), set in `/etc/aspell.conf` and
explicitly selected by `config/spelling/suggestions.py`.

See [Spelling suggestions](#spelling-suggestions-g14) for the `Super+C` workflow.
The selected word is copied automatically; suggestions are generated locally
and the chosen replacement is copied to the clipboard for pasting. Cancelling
or finding no suggestions leaves the copied word on the clipboard.
HyprCorrect's daemon, package, configuration and `input` group
requirement have been removed from the system configuration.

Stage the new files before building with the Git flake:

```sh
git add -A -- modules config packages hosts/g14 README.md
./build-g14.sh
./apply-g14.sh spelling
```

Log out and back in after applying to load the new binding and drop the old
`input` group membership. User-local HyprCorrect preferences are not deleted.

### Wi-Fi menu (iwmenu)

The G14 includes [iwmenu](https://github.com/e-tho/iwmenu), using the existing
Fuzzel launcher. NetworkManager uses iwd for Wi-Fi; NetworkManager continues
to manage IP addresses, DNS and wired connections. The Mac VM retains its
existing networking backend.

Build and apply the configuration from this repository:

```sh
./build-g14.sh
./apply-g14.sh iwmenu
```

Applying changes the Wi-Fi backend and may temporarily disconnect Wi-Fi.
Existing networks may ask for their password again. Apply locally on the G14.

Open **Wi-Fi Networks** from Fuzzel with `Super+D`, or run:

```sh
iwmenu --launcher fuzzel
```

Type to filter the menu, use the arrow keys to select an entry and press Enter.
Select the wireless adapter if prompted, then select a network and follow the
connection/password prompts. Escape closes the current menu. For menus that
remain open after actions and go back on Escape, use:

```sh
iwmenu --launcher fuzzel --interactive
```

The menus also expose available device and saved-network actions. Run iwmenu
as your normal user, not with sudo; `dan` already belongs to `wheel`, which the
NixOS iwd package permits to access its D-Bus interface.

If no adapter appears, check the service and wireless block state:

```sh
systemctl status iwd NetworkManager
rfkill list
```

### Hardware

The checked-in hardware configuration contains this GA401QM laptop's generated
filesystem UUIDs and boot modules. Model-specific settings in
`hosts/g14/laptop.nix` enable AMD graphics and microcode, NVIDIA RTX 3060 open
kernel modules with PRIME offload and power management, ASUS controls, SSD TRIM
and keyboard fixes. The configuration no longer imports files from `/etc/nixos`.

The desktop normally uses the AMD GPU. To run an application on the RTX 3060:

```sh
nvidia-offload <command>
```

Use `asusctl` for ASUS controls and `powerprofilesctl` to select a power profile.
On the G14, keyd maps Caps Lock to Escape when tapped alone and Control when
held with another key. Ctrl+M and Caps Lock+M send Return. These mappings apply
to all keyboards and work outside Hyprland as well.
The GPU addresses were verified on this machine. Hardware settings follow the
[upstream GA401 profile](https://github.com/NixOS/nixos-hardware/blob/master/asus/zephyrus/ga401/default.nix).

Add the new modules and scripts to Git before using the flake:

```sh
git add flake.nix modules hosts scripts *.sh
./create-lock-g14.sh
./build-g14.sh
./apply-g14.sh
```

To update the shared lock file, validate the selected host and apply it:

```sh
./update-lock-g14.sh
```

The Mac scripts continue to target `utm-on-mac14`. Both sets of scripts
use the same implementations under `scripts/` and the same `flake.lock`.
Update scripts evaluate only their selected host before applying it, so Mac
updates validate the Mac configuration independently. G14 display settings
use the preferred mode and automatic scale instead of the UTM virtual outputs.
