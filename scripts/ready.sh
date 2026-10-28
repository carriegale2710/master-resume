#!/usr/bin/env bash
# Usage: ./scripts/ready.sh <folder>   (human approval step: run only after a clean verify-claims)
[ $# -eq 1 ] || { echo "Usage: $0 <application-folder>" >&2; exit 1; }
exec bash "$(dirname "$0")/set-status.sh" "$1" ready
