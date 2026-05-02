#!/usr/bin/env bash
# Stage 04: terminal, screenshot tools, audio stack, bluetooth.
# Idempotent.
set -euo pipefail

echo "  installing Ghostty..."
sudo pacman -S --needed --noconfirm ghostty

echo "  installing screenshot stack (grim + slurp + satty)..."
sudo pacman -S --needed --noconfirm grim slurp
paru -S --needed --noconfirm satty

echo "  installing audio stack..."
sudo pacman -S --needed --noconfirm \
    pipewire \
    wireplumber \
    pipewire-pulse \
    pipewire-alsa \
    pavucontrol \
    playerctl

echo "  installing bluetooth..."
sudo pacman -S --needed --noconfirm bluez bluez-utils blueman
