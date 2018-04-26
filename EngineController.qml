import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3

Item {
    id: root

    height: rowLayout.implicitHeight + 10

    //Rectangle { anchors.fill: parent; color: "blue"; opacity: 0.2 }

    RowLayout {
        id: rowLayout
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10

        Rectangle {
            id: settingsButton
            width: 40
            height: width
            radius: height / 8
            color: "gray"

            Image {
                anchors.fill: parent
                anchors.margins: parent.height / 5
                source: engine.running ? "icons/settings.svg" : "icons/settings.svg"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: stackView.push(Qt.resolvedUrl("SettingsPage.qml"))
            }

        }

        Rectangle {
            id: playButton
            width: 40
            height: width
            radius: height / 8
            color: engine.running ? "gray" : "green"

            Image {
                anchors.fill: parent
                anchors.margins: parent.height / 5
                source: engine.running ? "icons/pause.svg" : "icons/play.svg"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: engine.running ? engine.pause() : engine.play()
            }

        }

        Rectangle {
            id: stopButton
            width: 40
            height: width
            radius: height / 8
            color: "gray"

            Image {
                anchors.fill: parent
                anchors.margins: parent.height / 5
                source: "icons/stop.svg"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: engine.stop()
            }

        }

        ProgressBar {
            id: progressBar
            Layout.fillWidth: true
            from: 0
            to: 100
            value: engine.progress
            Behavior on value {
                NumberAnimation {}
            }
        }

    }
}
