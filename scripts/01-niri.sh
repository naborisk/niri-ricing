#!/usr/bin/env bash
# Stage 01: niri compositor, login greeter (if none exists), XDG portals, polkit agent.
# Idempotent.
set -euo pipefail

echo "  installing niri + portals + Qt-wayland..."
sudo pacman -S --needed --noconfirm \
    niri \
    xdg-desktop-portal \
    xdg-desktop-portal-gnome \
    xdg-desktop-portal-gtk \
    xdg-utils \
    qt6-wayland

echo "  installing polkit agent (hyprpolkitagent, AUR)..."
paru -S --needed --noconfirm hyprpolkitagent

# Greeter: only install/enable greetd if no greeter is already enabled.
# This lets niri-ricing coexist with KDE/SDDM, GNOME/GDM, etc.
echo "  checking for existing greeter..."
existing_greeter=""
for unit in sddm.service gdm.service lightdm.service ly.service greetd.service; do
    if systemctl is-enabled "$unit" >/dev/null 2>&1; then
        existing_greeter="$unit"
        break
    fi
done

if [[ -n "$existing_greeter" ]]; then
    echo "  greeter already enabled: $existing_greeter — skipping greetd."
else
    echo "  no greeter enabled — installing greetd + tuigreet."
    sudo pacman -S --needed --noconfirm greetd greetd-tuigreet

    desired_config='[terminal]
vt = 1

[default_session]
command = "tuigreet --remember --asterisks --time --cmd niri-session"
user = "greeter"
'

    if [[ ! -f /etc/greetd/config.toml ]] || ! diff -q <(echo -n "$desired_config") /etc/greetd/config.toml >/dev/null 2>&1; then
        if [[ -f /etc/greetd/config.toml ]]; then
            sudo cp /etc/greetd/config.toml "/etc/greetd/config.toml.bak-$(date +%Y%m%d-%H%M%S)"
        fi
        echo -n "$desired_config" | sudo tee /etc/greetd/config.toml >/dev/null
        echo "  wrote /etc/greetd/config.toml"
    else
        echo "  /etc/greetd/config.toml already correct."
    fi

    sudo systemctl enable greetd.service
fi
