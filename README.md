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

The managed Neovim installation loads the current user's
`~/.config/nvim/init.lua`. To try the example configuration:

```sh
mkdir -p ~/.config/nvim
cp examples/nvim/init.lua ~/.config/nvim/init.lua
```

It prints `Hello world` when Neovim starts.

To label the generated boot entry:

```sh
sudo nixos-rebuild switch --flake .#nixos --impure
```

with `NIXOS_LABEL` set in the root environment, for example:

```sh
sudo NIXOS_LABEL=utm-sharing nixos-rebuild switch --flake .#nixos --impure
```
