#!/usr/bin/env bash

set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

sudo nixos-rebuild build \
  --flake .#utm-on-mac14 \
  --option experimental-features "nix-command flakes"
