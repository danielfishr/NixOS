#!/usr/bin/env bash

set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

sudo nixos-rebuild switch \
  --flake .#nixos \
  --option experimental-features "nix-command flakes"
