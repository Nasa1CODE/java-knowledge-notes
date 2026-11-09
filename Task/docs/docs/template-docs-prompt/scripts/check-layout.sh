#!/usr/bin/env bash
# Generic layout check. Extend REQUIRED_DOCS/OPTIONAL_REPOS in the project copy.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCS_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REQUIRED_DOCS=(README.md AGENTS.md project.md architecture.md specs/README.md databases/README.md)
FAIL=0

for file in "${REQUIRED_DOCS[@]}"; do
  if [ -f "$DOCS_DIR/$file" ]; then
    printf '[OK] %s\n' "$file"
  else
    printf '[MISS] %s\n' "$file"
    FAIL=1
  fi
done

if [ "$FAIL" -ne 0 ]; then
  exit 1
fi
