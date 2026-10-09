#!/usr/bin/env bash

set -euo pipefail

host=$1
shift

cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."

sudo nixos-rebuild build \
  --flake ".#${host}" \
  --option experimental-features "nix-command flakes"
