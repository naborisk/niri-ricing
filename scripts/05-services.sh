#!/usr/bin/env bash
# Stage 05: enable systemd services.
# Idempotent.
set -euo pipefail

# System-level: bluetooth.
if systemctl is-enabled bluetooth.service >/dev/null 2>&1; then
    echo "  bluetooth.service already enabled."
else
    echo "  enabling bluetooth.service..."
    sudo systemctl enable bluetooth.service
fi

# User-level: pipewire stack. Most Arch installs already enable these via the
# package install scripts, but be explicit. `--now` would also start them, but
# we leave starting to the user (avoids conflict if they're not in a graphical
# session yet).
for unit in pipewire pipewire-pulse wireplumber; do
    if systemctl --user is-enabled "$unit" >/dev/null 2>&1; then
        echo "  user unit $unit already enabled."
    else
        echo "  enabling user unit $unit..."
        systemctl --user enable "$unit" 2>/dev/null || true
    fi
done
