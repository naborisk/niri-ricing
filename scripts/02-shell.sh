#!/usr/bin/env bash
# Stage 02: Noctalia (with its custom Quickshell fork) + clipboard backend.
# Idempotent.
#
# Noctalia uses a fork of Quickshell called `noctalia-qs` that adds types like
# `PwAudioSpectrum` not present in upstream Quickshell. The fork conflicts with
# upstream `quickshell` (declares Provides=quickshell). Installing
# `noctalia-shell` from AUR pulls `noctalia-qs` plus all runtime deps:
# imagemagick, brightnessctl, ffmpeg, qt6-multimedia, python, wlr-randr.
#
# `noctalia-shell` installs to /etc/xdg/quickshell/noctalia-shell/ — Quickshell
# finds it there via XDG search path. Don't manually clone the noctalia-shell
# repo into ~/.config/quickshell/; that would shadow the package install and
# drift from `noctalia-qs`.
set -euo pipefail

# If upstream `quickshell` is installed (e.g., from a prior install.sh run that
# preceded this rewrite), remove it first so paru doesn't have to resolve the
# conflict interactively.
if pacman -Qq quickshell >/dev/null 2>&1; then
    echo "  removing upstream quickshell (conflicts with noctalia-qs)..."
    sudo pacman -R --noconfirm quickshell
fi

# Same for any prior manual clone of noctalia-shell — would shadow the package.
LEGACY_CLONE="${XDG_CONFIG_HOME:-$HOME/.config}/quickshell/noctalia-shell"
if [[ -d "$LEGACY_CLONE/.git" ]]; then
    echo "  removing legacy ~/.config/quickshell/noctalia-shell clone (now installed via package)..."
    rm -rf "$LEGACY_CLONE"
fi

echo "  installing noctalia-shell + noctalia-qs (AUR)..."
paru -S --needed --noconfirm noctalia-shell

echo "  installing clipboard backend (Noctalia optional dep)..."
sudo pacman -S --needed --noconfirm wl-clipboard cliphist
