#!/usr/bin/env bash

set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

nix --extra-experimental-features "nix-command flakes" flake update
nix --extra-experimental-features "nix-command flakes" flake check

sudo nixos-rebuild switch \
  --flake .#utm-on-mac14 \
  --option experimental-features "nix-command flakes"
