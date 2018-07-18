import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtCharts 2.2

import Eywa 1.0

Item {
    id: root

    ListView {
        id: blocksList
        anchors.fill: parent
        clip: true

        model: engine.blocksProxy

        delegate: ItemDelegate {
            width: parent.width

            contentItem: RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                spacing: 20
                Label {
                    Layout.alignment: Qt.AlignCenter
                    text: model.number
                }

                Label {
                    Layout.alignment: Qt.AlignCenter
                    text: model.timeString
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignCenter
                    //Rectangle { anchors.fill: parent; color: "blue"; opacity: 0.4 }

                    Label {
                        Layout.fillWidth: true
                        text: model.message
                    }

                    Label {
                        Layout.fillWidth: true
                        text: model.client
                    }

                    Label {
                        Layout.fillWidth: true
                        text: model.hash
                    }

                }
            }
        }
    }

}
