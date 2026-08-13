# NixOS configuration

Configuration for the `nixos` ARM64 UTM virtual machine.

## Apply

After adding the configuration files to Git, create and commit the lock file so
every rebuild uses the same Nixpkgs revision:

```sh
git add flake.nix hosts
nix --extra-experimental-features 'nix-command flakes' flake lock
git add flake.lock
```

Then apply the configuration from the repository root:

```sh
sudo nixos-rebuild switch --flake .#nixos \
  --extra-experimental-features 'nix-command flakes'
```

After that rebuild enables flakes system-wide, the extra feature flag can be
omitted.

To label the generated boot entry:

```sh
sudo nixos-rebuild switch --flake .#nixos --impure
```

with `NIXOS_LABEL` set in the root environment, for example:

```sh
sudo NIXOS_LABEL=utm-sharing nixos-rebuild switch --flake .#nixos --impure
```
