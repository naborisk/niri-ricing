# niri-ricing

A Niri + Quickshell rice for **pure Arch Linux**.

## Status

Decision phase complete. See [`docs/decisions.md`](docs/decisions.md) for the full log and rationale.

## Post-install manual steps

`install.sh` doesn't touch networking — set up NetworkManager / systemd-networkd / iwd yourself.

Three Noctalia settings to flip (via Noctalia's settings UI, or edit `~/.config/noctalia/settings.json` directly):

- `appLauncher.enableClipboardHistory` → `true`
- `appLauncher.terminalCommand` → `"ghostty -e"`
- `appLauncher.screenshotAnnotationTool` → `"satty"`

For per-machine output config: run `niri msg outputs`, write a `config/niri/cfg/display.local.kdl` (gitignored) with your display blocks, then uncomment the `include "./display.local.kdl"` line in `config/niri/cfg/display.kdl`.

## Stack at a glance

- **WM:** [niri](https://github.com/YaLTeR/niri) (scrollable-tiling Wayland)
- **Shell:** [Noctalia](https://github.com/noctalia-dev/noctalia-shell) (Quickshell-based) + a hand-rolled Quickshell config grown alongside it
- **Terminal:** [Ghostty](https://ghostty.org)
- **Palette:** Tokyonight Moon ([`colors/tokyonight-moon.json`](colors/tokyonight-moon.json))
- **Font:** Fira Code Nerd Font (`ttf-firacode-nerd` from `extra`)

## Install

Assumes a fresh Arch install with `base`, `git`, and `sudo` (i.e., an `archinstall` default).

```sh
git clone https://github.com/naborisk/niri-ricing ~/github/niri-ricing
cd ~/github/niri-ricing
./install.sh
```

Re-running `install.sh` is safe — every stage is idempotent.

## Layout

```
.
├── install.sh           # top-level dispatcher
├── scripts/             # numbered stages run by install.sh
├── config/              # mirrors ~/.config/ (symlinked by 99-link-dotfiles.sh)
├── shell/               # hand-rolled Quickshell config (run with `qs -c <name>`)
├── colors/              # palette JSONs
└── docs/
    └── decisions.md     # running log of choices and rationale
```

## Boundary with `~/dotfiles`

This repo is **independent** of the author's separate `~/dotfiles` repo. It installs its own Nerd Font and ships its own ghostty config. Two sources of truth for ghostty is accepted.
