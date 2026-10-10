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

## Hyprland

Shared Hyprland settings are managed in `config/hypr/hyprland.lua`. Display
settings specific to this virtual machine live in
`hosts/utm-on-mac14/hyprland.lua`. Nix combines both into the managed
`~/.config/hypr/hyprland.lua`. After applying the system configuration, log out
and select **Hyprland** from GDM's session menu.

Important defaults:

- `Super+Return`: open Kitty
- `Super+D`: open the application launcher
- `Super+E`: open Files
- `Super+B`: show/hide Waybar
- `Super+O`: focus the previously selected window
- `Super+Q`: close the active window
- `Super+X`: dismiss the latest Mako notification
- `Super+Shift+E`: exit Hyprland
- `Super+1` through `Super+9`: switch to workspaces 1–9
- `Super+0`: switch to workspace 10

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

## G14

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
held with another key. This applies to all keyboards and works outside Hyprland
as well.
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
