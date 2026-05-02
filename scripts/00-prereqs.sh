#!/usr/bin/env bash
# Stage 00: bootstrap the AUR helper (paru) and base-devel.
# Idempotent.
set -euo pipefail

# Sync repos and ensure base-devel is present (needed to build AUR packages).
sudo pacman -Syu --needed --noconfirm base-devel

# Install paru if missing.
if command -v paru >/dev/null 2>&1; then
    echo "paru already installed — skipping."
else
    echo "installing paru from AUR..."
    tmpdir="$(mktemp -d)"
    trap 'rm -rf "$tmpdir"' EXIT
    git clone --depth=1 https://aur.archlinux.org/paru-bin.git "$tmpdir/paru-bin"
    pushd "$tmpdir/paru-bin" >/dev/null
    makepkg -si --noconfirm
    popd >/dev/null
fi
