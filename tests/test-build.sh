#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fixture="$repo_root/tests/fixtures/dummy-resume.md"

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

contains() {
  [[ "$1" == *"$2"* ]] || fail "Expected output to contain: $2"
}

omits() {
  [[ "$1" != *"$2"* ]] || fail "Expected output to omit: $2"
}

filtered="$(bash "$repo_root/scripts/build.sh" --tags frontend,qa --md-only "$fixture")"
contains "$filtered" "Synthetic untagged summary text."
contains "$filtered" "Built a synthetic interface."
contains "$filtered" "Synthetic frontend detail."
contains "$filtered" "Checked a synthetic workflow."
contains "$filtered" "Synthetic public section text."
omits "$filtered" "Built a synthetic service."
omits "$filtered" "PRIVATE_SENTINEL"
omits "$filtered" "Synthetic editorial note"
omits "$filtered" "Tag key"
omits "$filtered" "Variant key"
omits "$filtered" '`frontend`'
omits "$filtered" '`qa`'

all_tags="$(bash "$repo_root/scripts/build.sh" --md-only "$fixture")"
contains "$all_tags" "Built a synthetic interface."
contains "$all_tags" "Built a synthetic service."
contains "$all_tags" "Checked a synthetic workflow."
omits "$all_tags" "PRIVATE_SENTINEL"

echo "PASS: build.sh filters tags and removes private metadata"
