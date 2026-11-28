#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

pattern='^[[:space:]]*key[[:space:]]*=[[:space:]]*"([^"]*)"[[:space:]]*$'
failures=0
checked=0

fail() {
  echo "FAIL $1: $2" >&2
  failures=$((failures + 1))
}

while IFS= read -r dir; do
  checked=$((checked + 1))
  backend="$dir/backend.tf"
  expected="${dir#stacks/}/terraform.tfstate"

  if [[ ! -f "$backend" ]]; then
    fail "$dir" "missing backend.tf"
    continue
  fi

  keys=()
  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ "$line" =~ $pattern ]]; then
      keys+=("${BASH_REMATCH[1]}")
    fi
  done < "$backend"

  if [[ ${#keys[@]} -eq 0 ]]; then
    fail "$dir" "no literal key = \"...\" line in $backend, expected key = \"$expected\""
  elif [[ ${#keys[@]} -gt 1 ]]; then
    fail "$dir" "${#keys[@]} key lines in $backend, expected exactly one"
  elif [[ "${keys[0]}" != "$expected" ]]; then
    fail "$dir" "backend key is \"${keys[0]}\", expected \"$expected\""
  else
    echo "ok   $dir: $expected"
  fi
done < <(find stacks -name '*.tf' -not -path '*/.terraform/*' -exec dirname {} \; | sort -u)

if [[ $checked -eq 0 ]]; then
  echo "FAIL no stacks found under stacks/" >&2
  exit 1
fi

if [[ $failures -gt 0 ]]; then
  echo "$failures of $checked stacks failed the backend key check" >&2
  exit 1
fi

echo "all $checked stacks have matching backend keys"
