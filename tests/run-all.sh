#!/usr/bin/env bash
# Run every tests/test-*.sh; keep going on failure, exit 1 if any failed.
cd "$(dirname "$0")/.." || exit 1

failed=()
for t in tests/test-*.sh; do
  echo "== $t"
  bash "$t" || failed+=("$t")
done

if [ ${#failed[@]} -gt 0 ]; then
  echo "FAILED: ${failed[*]}"
  exit 1
fi
echo "All tests passed"
