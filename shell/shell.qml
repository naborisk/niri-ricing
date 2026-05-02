//@ pragma UseQApplication

// Hand-rolled Quickshell skeleton for niri-ricing.
//
// This is a starting point, not a finished shell. It draws a top bar on every
// monitor with the current time, in Tokyonight Moon colors. Grow it module by
// module under `modules/`; replace pieces of Noctalia as they're ready.
//
// Run alongside Noctalia:
//     qs -c niri-rice            # this shell
//     qs -c noctalia-shell       # Noctalia (still doing the heavy lifting)
//
// Quickshell docs: https://quickshell.outfoxxed.me/docs/
// API surface evolves between versions — re-check imports on upgrades.

import Quickshell
import Quickshell.Wayland
import QtQuick

import "modules"

Variants {
    model: Quickshell.screens

    PanelWindow {
        required property var modelData
        screen: modelData

        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: 32
        color: "transparent"

        Bar {
            anchors.fill: parent
        }
    }
}
