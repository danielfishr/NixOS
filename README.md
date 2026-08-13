# NixOS configuration

Configuration for the `nixos` ARM64 UTM virtual machine.

## Apply

After adding the configuration files to Git, create and commit the lock file so
every rebuild uses the same Nixpkgs revision:

```sh
git add flake.nix hosts
./create-lock.sh
git add flake.lock
```

Build the configuration without activating it:

```sh
./build.sh
```

Apply the configuration:

```sh
./apply.sh
```

## Neovim

The managed Neovim installation loads `config/nvim/init.lua`, followed by the
current user's `~/.config/nvim/init.lua` or `init.vim` when present. Apply
changes to the managed example with:

```sh
./apply.sh
```

It prints `Hello world` when Neovim starts.

## Hyprland

The Hyprland configuration is managed in `config/hypr/hyprland.lua` and linked
to `~/.config/hypr/hyprland.lua` when that path does not already exist. After
applying the system configuration, log out and select **Hyprland** from GDM's
session menu.

Important defaults:

- `Super+Return`: open Kitty
- `Super+Space`: open the application launcher
- `Super+E`: open Files
- `Super+Shift+W`: close the active window
- `Super+Shift+E`: exit Hyprland
- `Super+1` through `Super+9`: switch workspaces

`Super+Q` is deliberately unbound.

To label the generated boot entry:

```sh
sudo nixos-rebuild switch --flake .#nixos --impure
```

with `NIXOS_LABEL` set in the root environment, for example:

```sh
sudo NIXOS_LABEL=utm-sharing nixos-rebuild switch --flake .#nixos --impure
```
