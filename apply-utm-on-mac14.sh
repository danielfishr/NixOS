#!/usr/bin/env bash

set -euo pipefail

exec bash "$(dirname -- "${BASH_SOURCE[0]}")/scripts/apply.sh" utm-on-mac14 "$@"
