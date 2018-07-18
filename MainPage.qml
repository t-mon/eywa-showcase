import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtCharts 2.2

Page {
    id: root

    Component.onCompleted: engine.dataManager.refresh()

    ColumnLayout {
        anchors.fill: parent

        TabBar {
            id: bar
            width: parent.width
            Layout.fillWidth: true

            TabButton {
                text: qsTr("Haushalt 1")
            }
            TabButton {
                text: qsTr("Haushalt 2")
            }
            TabButton {
                text: qsTr("Haushalt 3")
            }
            TabButton {
                text: qsTr("Haushalt 4")
            }
            TabButton {
                text: qsTr("Haushalt 5")
            }
            TabButton {
                text: qsTr("Grid")
            }
            TabButton {
                text: qsTr("Block chain")
            }
        }

        SwipeView {
            id: swipeView
            Layout.fillWidth: true
            Layout.fillHeight: true

            currentIndex: bar.currentIndex

            HousholdView {
                housholdNumber: 1
            }

            HousholdView {
                housholdNumber: 2
            }

            HousholdView {
                housholdNumber: 3
            }

            HousholdView {
                housholdNumber: 4
            }

            HousholdView {
                housholdNumber: 5
            }

            OverallView {
                id: gridView
            }

            BlockChainView {
                id: blockChainView
            }
        }

        EngineController {
            id: engineController
            Layout.fillWidth: true
        }
    }
}
