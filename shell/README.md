# shell/ — hand-rolled Quickshell config

This is **your** Quickshell config, grown incrementally alongside Noctalia.
Noctalia owns the bar / launcher / lock / notifications today; this shell starts
as a parallel top bar and gradually takes over pieces as you build them.

## Running

The link script symlinks this directory into `~/.config/quickshell/niri-rice`.
Run it with:

```sh
qs -c niri-rice
```

You can run both at once. They will both create wayland-layer-shell surfaces;
arrange anchors/exclusion-zones so they don't collide.

```sh
qs -c noctalia-shell &        # full shell — bar, launcher, lock, etc.
qs -c niri-rice &             # this — currently a top bar
```

To make this the default shell later, replace the autostart line in
`config/niri/cfg/autostart.kdl`.

## Layout

```
shell/
├── shell.qml           # entry point — Variants over screens, one PanelWindow each
└── modules/
    └── Bar.qml         # top bar contents
```

## Growing this

Suggested order (each is a self-contained module — add, test, commit):

1. **Workspaces** — subscribe to niri IPC `event-stream` for workspace changes,
   render boxes for active/inactive workspaces.
2. **Tray** — `Quickshell.Services.SystemTray` items, render icons.
3. **Battery** — `Quickshell.Services.UPower` for charge + state.
4. **Network** — `Quickshell.Io` to shell out to `nmcli` (no built-in NM yet).
5. **MPRIS** — `Quickshell.Services.Mpris` for media title/play state.
6. **Notifications surface** — replace Noctalia's; this is the moment you can
   drop `qs -c noctalia-shell` from autostart.

## Notes

- Quickshell's API surface evolves between versions. Re-check imports if you
  upgrade and things break: <https://quickshell.outfoxxed.me/docs/>.
- Colors should source from `colors/tokyonight-moon.json` rather than being
  hard-coded once you build a theme module. Right now they're inline for speed.
- IPC reconnect: when you `qs -c niri-rice` reload, niri IPC subscriptions
  drop and resume — handle errors gracefully in any module that subscribes.
