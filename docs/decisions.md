# Decisions log

Running log of ricing choices made during the niri-ricing setup. Append new entries; supersede earlier decisions with new entries rather than rewriting.

## 2026-05-02 — Quickshell shell: Noctalia + incremental hand-roll

**Chosen:** stay on Noctalia as the working baseline; develop a hand-rolled QML config in `shell/` alongside it, swap pieces over time.

**Why:** Caelestia is Hyprland-first (second-class niri support); from-scratch means weeks of bare desktop. Noctalia was Niri-first and matches the existing IPC keybinds.

## 2026-05-02 — Palette: Tokyonight Moon

**Chosen:** Tokyonight Moon as the static base palette in `colors/tokyonight-moon.json`. Semantic mapping is **deuteranomaly-aware**: blue/cyan for success, red `#ff757f` for danger.

**Why:** user already runs Tokyonight in Noctalia; Moon variant has highest contrast; broadest port ecosystem on Arch. Blue↔red is a safe color-blindness axis; red↔green is not — never use red+green for semantic pairs in this rice. Future palettes drop into `colors/<name>.json`; matugen-from-wallpaper deferred.

## 2026-05-02 — Terminal: Ghostty

**Chosen:** Ghostty replaces Alacritty as the niri terminal keybind. Niri-ricing ships its own Tokyonight-themed Ghostty config under `config/ghostty/`.

**Why:** user is migrating to Ghostty (already used on macOS). Acceptable that this overlaps with the user's separate `~/dotfiles` ghostty config — the rice repo prioritizes self-containment.

## 2026-05-02 — Repo independence and scope

**Chosen:** niri-ricing is fully self-contained on a fresh Arch install. Installs Fira Code Nerd Font itself via `pacman -S ttf-firacode-nerd`. Does not depend on, source from, or call the user's separate `~/dotfiles` repo.

**Why:** user prefers the rice repo to stand alone on a fresh Arch box. Trades duplication for portability.

## 2026-05-02 — Install script structure

- **Stages:** numbered scripts under `scripts/NN-name.sh`, dispatched by top-level `install.sh`.
- **Idempotency:** every stage checks state before acting (`pacman -Qq`, `[ -L symlink ]`, etc.). Re-running is a "sync this machine" workflow.
- **AUR helper:** paru (bootstrapped from `paru-bin` if missing).
- **Linking:** plain `ln -sfn` in `99-link-dotfiles.sh`. No stow.
- **Bootstrap floor:** assumes `base` + `git` + `sudo` (output of a normal `archinstall`). No AUR helper assumed.
- **Excluded:** no `fonts/` or `wallpapers/` directories in the repo. Fonts via pacman; wallpapers stay on the user's local machine.

## 2026-05-02 — Daemons that overlap with Noctalia: skip them all

**Chosen:** no standalone notification daemon (mako/swaync), wallpaper engine (swww/swaybg), or lockscreen (swaylock/hyprlock). Noctalia owns all three. Two notification daemons can't coexist on `org.freedesktop.Notifications`; standalone wallpaper engines fight Noctalia's layer-shell wallpaper.

**Idle:** deferred. Noctalia or none for now; swayidle/hypridle can be added later if auto-lock/DPMS-off is wanted.

## 2026-05-02 — Launcher: Noctalia only

**Chosen:** stick with Noctalia's launcher (`Mod+CTRL+Return`, `ALT+SPACE`). No supplemental fuzzel/anyrun/walker.

**Why:** keeps the dep surface small; Noctalia's launcher does what's needed (apps, sessions, settings search).

## 2026-05-02 — Screenshot: grim + slurp + satty

**Chosen:** `Mod+Shift+S` runs grim+slurp piped to satty, saves to `~/Pictures/screenshots/screenshot-<timestamp>.png` and copies to clipboard. Niri's built-in `screenshot`/`screenshot-screen`/`screenshot-window` actions are no longer bound (`CTRL+Shift+1/2/3` removed from keybinds).

**Why:** `Mod+Shift+S` is HHKB-friendly (no Print key reachable) and matches Windows muscle memory. satty adds annotation on top of niri's built-in capability.

## 2026-05-02 — Clipboard: Noctalia + cliphist + wl-clipboard

**Chosen:** install `cliphist` and `wl-clipboard`; flip Noctalia's `enableClipboardHistory: true` to surface history through its launcher. No separate picker.

**Manual flip** in `~/.config/noctalia/settings.json`:
```json
"enableClipboardHistory": true,
```

## 2026-05-02 — Theming: tokyonight-gtk-theme-git + Bibata + Papirus + Qt-via-GTK

**Chosen:**
- GTK: `tokyonight-gtk-theme-git` (AUR; same Tokyonight palette family). Originally planned to use Magnetic-Tokyo, but it isn't AUR-packaged and would require manual `meson` build. Swapped during install testing — see commit notes.
- Cursor: `Bibata-Modern-Ice` (AUR: `bibata-cursor-theme-bin`); replaces capitaine-cursors in `cfg/misc.kdl`
- Icons: `papirus-icon-theme` + `papirus-folders-git`, recolored with `papirus-folders -C cat-blue --theme Papirus-Dark`
- Qt: inherit from GTK (`QT_QPA_PLATFORMTHEME=gtk3` already in `cfg/misc.kdl`); no qt6ct, no kvantum
- `gtk-engine-murrine` was dropped from Arch's `[extra]` and is AUR-only now (GTK2-era). We don't install it; modern GTK4/libadwaita themes don't need it.

## 2026-05-02 — Infrastructure (polkit / portals / audio / bluetooth / network / greeter)

**Chosen:**
- Polkit agent: `hyprpolkitagent` (AUR), autostarted from `cfg/autostart.kdl` via `/usr/lib/hyprpolkitagent`
- Portals: `xdg-desktop-portal`, `xdg-desktop-portal-gnome` (file picker + screencast on niri), `xdg-desktop-portal-gtk` (fallback)
- Audio: `pipewire`, `wireplumber`, `pipewire-pulse`, `pipewire-alsa`, `playerctl`, `pavucontrol`. No jack/easyeffects.
- Bluetooth: `bluez`, `bluez-utils`, `blueman`. `bluetooth.service` enabled by stage 05.
- Network: **user handles manually** — install scripts don't touch networking.
- Greeter: `greetd` + `greetd-tuigreet`, but **only installed if no greeter is already enabled** (sddm/gdm/lightdm/ly/greetd) — lets the repo coexist with KDE Plasma / GNOME on the same box. `/etc/greetd/config.toml` is backed up before being overwritten.

**Misc deps:** `xdg-utils`, `qt6-wayland`, `gtk-engine-murrine`.

## 2026-05-02 — Niri config lift

Lifted `~/.config/niri/cfg/*.kdl` into `config/niri/cfg/` with the following edits:

- `keybinds.kdl`: `Mod+Return` spawns `ghostty` (was `alacritty`); old `CTRL+Shift+1/2/3` screenshot binds removed; new `Mod+Shift+S` binds grim+slurp+satty.
- `misc.kdl`: `xcursor-theme "Bibata-Modern-Ice"` (was `capitaine-cursors`).
- `autostart.kdl`: added `spawn-at-startup "/usr/lib/hyprpolkitagent"`.
- `display.kdl`: replaced hardcoded DP-1/DP-2 with a commented template; per-machine output config goes in `display.local.kdl` (gitignored), pulled in via `// include "./display.local.kdl"` inside `display.kdl` (uncomment after creating).
- `animation.kdl`, `input.kdl`, `layout.kdl`, `rules.kdl`: lifted unchanged.

`Mod+Home`/`Mod+End` for column-first/last kept despite HHKB awkwardness — rarely used.

## 2026-05-02 — Manual Noctalia settings to flip post-install

These three settings in `~/.config/noctalia/settings.json` need flipping (do via Noctalia's settings UI, or edit directly):

| Setting | Path | Value |
|---|---|---|
| Enable clipboard history | `appLauncher.enableClipboardHistory` | `true` |
| Terminal command | `appLauncher.terminalCommand` | `"ghostty -e"` |
| Screenshot annotation tool | `appLauncher.screenshotAnnotationTool` | `"satty"` |

The repo ships only `colors.json` for Noctalia (Tokyonight Moon mapping), not the full settings.json — settings.json is mostly per-machine state.

## 2026-05-02 — Quickshell skeleton in `shell/`

Created a minimal Quickshell config in `shell/` that runs as a second config alongside Noctalia. Linked by stage 99 to `~/.config/quickshell/niri-rice`. Run with `qs -c niri-rice`. Currently shows a top bar with a clock; ready to grow modules per `shell/README.md` plan.
