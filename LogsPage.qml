import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtCharts 2.2

Page {
    id: root
    header: ToolBar {

        background: Rectangle {
            implicitHeight: 40
            color: "#888888"
        }

        RowLayout {
            anchors.fill: parent

            ToolButton {
                text: qsTr("<")
                onClicked: stackView.pop()
            }

            Label {
                Layout.fillWidth: true
                text: "Logs " + housHold.name
            }
        }
    }


    property var housHold: null

    ListView {
        id: logsList
        anchors.fill: parent
        clip: true
        model: housHold.logEntriesProxy()

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
                    text: model.timeString
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignCenter

                    Label {
                        Layout.fillWidth: true

                        text: model.message
                    }

                    Label {
                        Layout.fillWidth: true
                        text: model.messageType
                    }

                }
            }
        }
    }
}
