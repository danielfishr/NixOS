# NixOS configuration

Configuration for the `utm-on-mac14` ARM64 UTM virtual machine.

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

The system includes both the Codex CLI and the ARM64 Linux desktop app. Run
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
- `Super+O`: focus the previously selected window
- `Super+X`: close the active window
- `Super+Shift+E`: exit Hyprland
- `Super+1` through `Super+9`: switch to workspaces 1–9
- `Super+0`: switch to workspace 10

`Super+Q` is deliberately unbound.

To label the generated boot entry:

```sh
sudo nixos-rebuild switch --flake .#utm-on-mac14 --impure
```

with `NIXOS_LABEL` set in the root environment, for example:

```sh
sudo NIXOS_LABEL=utm-sharing nixos-rebuild switch --flake .#utm-on-mac14 --impure
```
