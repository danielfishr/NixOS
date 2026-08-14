#!/usr/bin/env bash

set -euo pipefail

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

nix --extra-experimental-features "nix-command flakes" flake update
nix --extra-experimental-features "nix-command flakes" flake check

./apply-utm-on-mac14.sh "$@"
