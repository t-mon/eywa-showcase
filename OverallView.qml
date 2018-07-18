import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtCharts 2.2

import Eywa 1.0

Item {
    id: root

    Flickable {
        id: flickable
        anchors.fill: parent
        contentHeight: gridColumn.height
        clip: true

        ColumnLayout {
            id: gridColumn
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top

            Label { text: "Grid" }


        }


        //        }

        //        // Summe aus alles haushalten von "Gesamtverbrauch [kW]" (Column W)

        //        // TODO: iteration wechseln und volle grafik sehen

        ////        //============================================================================================================
        ////        ChartView {
        ////            id: chartView2
        ////            Layout.preferredHeight: flickable.height / 2
        ////            Layout.fillWidth: true

        ////            legend.visible: true
        ////            legend.alignment: Qt.AlignBottom

        ////            theme: ChartView.ChartThemeDark

        ////            animationDuration: engine.simulationSpeed
        ////            animationOptions: settings.animated ? ChartView.SeriesAnimations : ChartView.NoAnimation
        ////            animationEasingCurve.type: Easing.Linear

        ////            antialiasing: true

        ////            ValueAxis {
        ////                id: energyAxis
        ////                min: -4
        ////                max: 12
        ////                titleText: "Energie [kW]"
        ////                gridVisible: false
        ////                labelFormat: "%i"
        ////            }

        ////            ValueAxis {
        ////                id: timeAxis2
        ////                min: 0
        ////                max: 23
        ////                tickCount: 10
        ////                labelFormat: "%i"
        ////            }
        ////        }
        //    }
    }
}
