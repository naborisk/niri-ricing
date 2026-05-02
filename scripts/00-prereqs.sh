#!/usr/bin/env bash
# Stage 00: bootstrap the AUR helper (paru) and base-devel.
# Idempotent.
#
# Note: we build paru from source (not paru-bin). paru-bin ships a precompiled
# binary linked against a specific libalpm.so.NN — when Arch bumps pacman's
# libalpm soname and the AUR maintainer hasn't rebuilt yet, paru-bin fails with
# "libalpm.so.15: cannot open shared object file". Building from source links
# against whatever libalpm is currently installed, so it can't drift.
set -euo pipefail

# Sync repos and ensure base-devel + rust (rust is needed to build paru).
sudo pacman -Syu --needed --noconfirm base-devel rust

# Install paru if missing.
if command -v paru >/dev/null 2>&1; then
    echo "paru already installed — skipping."
else
    echo "building paru from AUR source..."
    tmpdir="$(mktemp -d)"
    trap 'rm -rf "$tmpdir"' EXIT
    git clone --depth=1 https://aur.archlinux.org/paru.git "$tmpdir/paru"
    pushd "$tmpdir/paru" >/dev/null
    makepkg -si --noconfirm
    popd >/dev/null
fi
