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

echo "  installing Papirus icons..."
# Note: gtk-engine-murrine was dropped from Arch's [extra] repo (now AUR-only,
# GTK2-era engine). Magnetic-Tokyo isn't AUR-packaged. We use the AUR
# tokyonight-gtk-theme-git port instead — same palette family, easy install.
sudo pacman -S --needed --noconfirm papirus-icon-theme

echo "  installing tokyonight GTK theme + Bibata cursor (AUR)..."
paru -S --needed --noconfirm tokyonight-gtk-theme-git bibata-cursor-theme-bin papirus-folders-git

echo "  recoloring Papirus folders to Tokyo-blue..."
if command -v papirus-folders >/dev/null 2>&1; then
    papirus-folders -C cat-blue --theme Papirus-Dark >/dev/null || true
fi

echo "  refreshing font cache..."
fc-cache -f >/dev/null
