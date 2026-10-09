#!/usr/bin/env bash

set -euo pipefail

host=$1
shift

cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."

nix --extra-experimental-features "nix-command flakes" flake lock
