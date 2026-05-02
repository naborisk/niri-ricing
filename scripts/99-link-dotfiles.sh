#!/usr/bin/env bash
# Stage 99: symlink config/*/ into ~/.config/, plus shell/ into ~/.config/quickshell/niri-rice.
# Idempotent: existing matching symlinks are skipped; existing non-symlink files are backed up.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DST="${XDG_CONFIG_HOME:-$HOME/.config}"
mkdir -p "$DST"

# link_one <source-path> <target-path>
link_one() {
    local src="$1"
    local target="$2"
    local name
    name="$(basename "$target")"

    if [[ -L "$target" && "$(readlink -f "$target")" == "$(readlink -f "$src")" ]]; then
        echo "  $name — already linked"
        return 0
    fi

    if [[ -e "$target" && ! -L "$target" ]]; then
        local backup="$target.backup-$(date +%Y%m%d-%H%M%S)"
        echo "  $name — exists, backing up to $(basename "$backup")"
        mv "$target" "$backup"
    elif [[ -L "$target" ]]; then
        echo "  $name — relinking (was pointing to $(readlink "$target"))"
        rm "$target"
    fi

    mkdir -p "$(dirname "$target")"
    ln -sfn "$src" "$target"
    echo "  $name — linked"
}

# 1. Standard config/*/ → ~/.config/*/
shopt -s nullglob
for entry in "$REPO_DIR"/config/*; do
    name="$(basename "$entry")"
    [[ "$name" == ".gitkeep" ]] && continue
    link_one "$entry" "$DST/$name"
done

# 2. shell/ → ~/.config/quickshell/niri-rice (alongside Noctalia)
if [[ -f "$REPO_DIR/shell/shell.qml" ]]; then
    link_one "$REPO_DIR/shell" "$DST/quickshell/niri-rice"
fi
