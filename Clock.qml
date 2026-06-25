import Quickshell
import QtQuick

Text {
    text: Qt.formatDateTime(clock.date, "hh:mm")
    color: "#3dd1b0"
    font.family: "SF Mono"
    font.letterSpacing: -0.5
    font.pixelSize: 15
    font.weight: 700

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}