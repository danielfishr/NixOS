#!/usr/bin/env bash

set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

if (( $# > 1 )); then
  echo "Usage: $0 [GENERATION_LABEL]" >&2
  exit 2
fi

if (( $# == 1 )); then
  generation_label=$1
else
  read -r -p "Generation label: " generation_label
fi

if [[ ! $generation_label =~ ^[a-zA-Z0-9:_.-]+$ ]]; then
  echo "Generation label may contain only letters, numbers, colon, underscore, dot, and hyphen." >&2
  exit 2
fi

sudo env NIXOS_LABEL="$generation_label" nixos-rebuild switch \
  --flake .#utm-on-mac14 \
  --impure \
  --option experimental-features "nix-command flakes"
