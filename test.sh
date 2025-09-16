#!/usr/bin/env bash
set -eu

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

# run app
OUT="$("$PWD/app/greet.sh" "CI" )"

# expected output
EXPECTED="Hello, CI!"

if [ "$OUT" != "$EXPECTED" ]; then
  echo "Test failed: expected '$EXPECTED' but got '$OUT'" >&2
  exit 1
fi

echo "test_greet: OK"
