#!/usr/bin/env bash

set -euo pipefail

host=$1
shift

cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."

nix --extra-experimental-features "nix-command flakes" flake update
nix --extra-experimental-features "nix-command flakes" eval \
  ".#nixosConfigurations.${host}.config.system.build.toplevel.drvPath"

"./apply-${host}.sh" "$@"
