import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import "config.js" as Config

Scope {
    id: root
    property bool centerOpen: false
        property var history: ListModel { }
            NotificationServer {
                id: server
                actionsSupported: true
                bodySupported: true
                imageSupported: true

                onNotification: n => {
                history.insert(0, {
                summary: n.summary,
                body: n.body,
                appName: n.appName,
                urgency: n.urgency,
                time: Qt.formatDateTime(new Date(), "HH:mm")
            })
            n.tracked = true
        }
    }

    IpcHandler {
        target: "notifications"
        function toggle(): void
        { root.centerOpen = !root.centerOpen }
                function show(): void
                { root.centerOpen = true }
                function hide(): void
                { root.centerOpen = false }
            }

        PanelWindow {
            anchors { top: true; right: true }
            margins { top: 12; right: 12 }
            implicitWidth: 380
            implicitHeight: Math.max(1, column.implicitHeight)
            color: "transparent"

            exclusionMode: ExclusionMode.Ignore

            ColumnLayout {
                id: column
                width: parent.width
                spacing: 10

            Repeater {
                model: server.trackedNotifications
                delegate: Rectangle {
                    id: card
                    required property var modelData

                        Timer {
                            running: card.modelData.urgency !== NotificationUrgency.Critical
                            interval: Config.Notifications.timeout
                            onTriggered: card.modelData.dismiss()
                            }

                            Layout.fillWidth: true
                            Layout.preferredHeight: 60
                            radius: 8
                            color: Config.colors.bg
                            border.width: 2
                            border.color: modelData.urgency === NotificationUrgency.Critical
                            ? Config.colors.red : Config.colors.purple

                    RowLayout {
                        id: layout
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10

                        Image {
                            Layout.preferredHeight: 36
                            Layout.preferredWidth: 36
                            Layout.alignment: Qt.AlignTop
                            fillMode: Image.PreserveAspectFit
                            visible: source.toString() !== ""
                            source: card.modelData.image || card.modelData.appIcon || ""
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            Text {
                                Layout.fillWidth: true
                                text: card.modelData.summary
                                color: Config.colors.cyan
                                font.family: Config.bar.fontFamily
                                font.pixelSize: Config.bar.fontSize
                                font.bold: true
                                elide: Text.ElideRight
                            }
                            Text {
                                Layout.fillWidth: true
                                visible: text !== ""
                                text: card.modelData.body
                                color: Config.colors.fg
                                font.family: Config.bar.fontFamily
                                font.pixelSize: Config.bar.fontSize - 1
                                wrapMode: Text.WordWrap
                            }
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: card.modelData.dismiss()
                    }
                }
            }
        }
    }

    // notification center
    PanelWindow {
        visible: root.centerOpen
        anchors { top: true; right: true }
        margins { top: 12; right: 12 }
        implicitWidth: 380
        implicitHeight: centerCol.implicitHeight + 24
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore

        Rectangle {

            anchors.fill: parent
            radius: 10
            color: Config.colors.bg
            border.width: 2
            border.color: Config.colors.purple

            ColumnLayout {
                id: centerCol
                anchors.fill: parent
                anchors.margins: 12
                spacing: 10

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        Layout.fillWidth: true
                        text: "Notifications"
                        color: Config.colors.cyan
                        font.family: Config.bar.fontFamily
                        font.pixelSize: Config.bar.fontSize + 2
                        font.bold: true
                    }
                    Text {
                        text: "Clear All"
                        visible: history.count > 0
                        color: Config.colors.red
                        font.family: Config.bar.fontFamily
                        font.pixelSize: Config.bar.fontSize - 1
                        MouseArea {
                            anchors.fill: parent
                            onClicked: history.Clear()
                        }
                    }

                }
            }
        }
    }
}

