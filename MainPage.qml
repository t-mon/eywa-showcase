import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtCharts 2.2

Page {
    id: root

    ColumnLayout {
        anchors.fill: parent

        SwipeView {
            id: swipeView
            Layout.fillWidth: true
            Layout.fillHeight: true

            HousholdView {
                housholdNumber: 0
            }

            HousholdView {
                housholdNumber: 1
            }
        }

        EngineController {
            id: engineController
            Layout.fillWidth: true
        }
    }
}
