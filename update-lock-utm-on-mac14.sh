#!/usr/bin/env bash

set -euo pipefail

exec bash "$(dirname -- "${BASH_SOURCE[0]}")/scripts/update-lock.sh" utm-on-mac14 "$@"
