import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

ShellRoot {
    PanelWindow {
        anchors {
            top: true
            left: true
            right: true
        }
        implicitHeight: 30
        color: "#040e0d"

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 14
            anchors.rightMargin: 14
            spacing: 8

            Workspaces {}

            Item { Layout.fillWidth: true}
            
            RowLayout {
                spacing: 25

                Volume {}
                Network {}
                Clock {}
            }
        }

        SystemClock {
            id: clock
            precision: SystemClock.Minutes
        }
    }
}
