#!/usr/bin/env bash
# Stage 03: fonts (Fira Code Nerd + Noto), GTK theme, cursor, icon theme.
# Idempotent.
set -euo pipefail

echo "  installing fonts..."
sudo pacman -S --needed --noconfirm \
    ttf-firacode-nerd \
    ttf-dejavu \
    noto-fonts \
    noto-fonts-cjk \
    noto-fonts-emoji

echo "  installing GTK plumbing + Papirus icons..."
sudo pacman -S --needed --noconfirm gtk-engine-murrine papirus-icon-theme

echo "  installing magnetic-tokyo GTK theme + Bibata cursor (AUR)..."
paru -S --needed --noconfirm magnetic-tokyo-gtk-theme bibata-cursor-theme-bin papirus-folders-git

echo "  recoloring Papirus folders to Tokyo-blue..."
if command -v papirus-folders >/dev/null 2>&1; then
    papirus-folders -C cat-blue --theme Papirus-Dark >/dev/null || true
fi

echo "  refreshing font cache..."
fc-cache -f >/dev/null
