#!/usr/bin/env bash
# Top-level installer. Runs scripts/NN-*.sh stages in order.
# Idempotent: safe to re-run.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR"

# --- bootstrap floor: base + git + sudo are assumed present.
for cmd in sudo git; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "error: '$cmd' is required but not found." >&2
        echo "       install with: pacman -S $cmd" >&2
        exit 1
    fi
done

if [[ ! -f /etc/arch-release ]]; then
    echo "error: this installer targets Arch Linux." >&2
    exit 1
fi

# --- run stages in numeric order; skip any not yet authored.
shopt -s nullglob
stages=(scripts/[0-9][0-9]-*.sh)
if (( ${#stages[@]} == 0 )); then
    echo "no stages found in scripts/ — nothing to do."
    exit 0
fi

for stage in "${stages[@]}"; do
    echo
    echo "==> $stage"
    bash "$stage"
done

echo
echo "done. log of choices: docs/decisions.md"
