#!/usr/bin/env bash

set -euo pipefail

exec bash "$(dirname -- "${BASH_SOURCE[0]}")/scripts/build.sh" utm-on-mac14 "$@"
