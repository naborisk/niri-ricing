#!/usr/bin/env bash
# Stage 02: Quickshell + Noctalia + clipboard backend.
# Idempotent.
set -euo pipefail

echo "  installing Quickshell (AUR)..."
paru -S --needed --noconfirm quickshell

echo "  installing clipboard backend..."
sudo pacman -S --needed --noconfirm wl-clipboard cliphist

# Noctalia is distributed as a Quickshell config (cloned to ~/.config/quickshell/noctalia-shell).
# Run with `qs -c noctalia-shell`. AUR may have a package; we clone for reproducibility.
NOCTALIA_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/quickshell/noctalia-shell"

if [[ -d "$NOCTALIA_DIR/.git" ]]; then
    echo "  Noctalia already cloned — pulling latest."
    git -C "$NOCTALIA_DIR" pull --ff-only
else
    echo "  cloning Noctalia to $NOCTALIA_DIR..."
    mkdir -p "$(dirname "$NOCTALIA_DIR")"
    git clone --depth=1 https://github.com/noctalia-dev/noctalia-shell.git "$NOCTALIA_DIR"
fi
