// Top bar — minimal starting layout.
// Left:   placeholder for workspace indicator (TODO: niri IPC subscription)
// Center: clock
// Right:  placeholder for tray / battery / network (TODO)

import QtQuick
import QtQuick.Layouts

Rectangle {
    color: "#222436"          // bg from tokyonight-moon
    border.color: "#3b4261"   // ui.border
    border.width: 0           // toggle to 1 for a subtle outline

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 12

        // ─── Left ───
        Text {
            text: "niri-rice"
            color: "#828bb8"  // ui.fg_dim
            font.family: "FiraCode Nerd Font"
            font.pixelSize: 12
        }

        Item { Layout.fillWidth: true }   // spacer

        // ─── Center: clock ───
        Text {
            id: clock
            color: "#c8d3f5"  // ui.fg
            font.family: "FiraCode Nerd Font"
            font.pixelSize: 13
            text: Qt.formatDateTime(new Date(), "ddd  hh:mm")

            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: clock.text = Qt.formatDateTime(new Date(), "ddd  hh:mm")
            }
        }

        Item { Layout.fillWidth: true }   // spacer

        // ─── Right ───
        Text {
            text: "—"   // placeholder
            color: "#828bb8"
            font.family: "FiraCode Nerd Font"
            font.pixelSize: 12
        }
    }
}
