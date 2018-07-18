import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtCharts 2.2

Page {
    id: root

    header: ToolBar {

        RowLayout {
            anchors.fill: parent
            ToolButton {
                text: qsTr("x")
                onClicked: stackView.pop()
            }
        }

    }
}
