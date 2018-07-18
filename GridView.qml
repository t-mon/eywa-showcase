import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtCharts 2.2

Item {
    id: root

    property int currentIterationNumber: engine.currentIteration

    Flickable {
        id: flickable
        anchors.fill: parent
        contentHeight: chartsColumn.height
        clip: true

        ColumnLayout {
            id: chartsColumn
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top

        }

        // Summe aus alles haushalten von "Gesamtverbrauch [kW]" (Column W)

        // TODO: iteration wechseln und volle grafik sehen



        //============================================================================================================
        ChartView {
            id: chartView2
            Layout.preferredHeight: flickable.height / 2
            Layout.fillWidth: true

            legend.visible: true
            legend.alignment: Qt.AlignBottom

            theme: ChartView.ChartThemeDark

            animationDuration: engine.simulationSpeed
            animationOptions: settings.animated ? ChartView.SeriesAnimations : ChartView.NoAnimation
            animationEasingCurve.type: Easing.Linear

            antialiasing: true

            ValueAxis {
                id: energyAxis
                min: -4
                max: 12
                titleText: "Energie [kW]"
                gridVisible: false
                labelFormat: "%i"
            }

            ValueAxis {
                id: timeAxis2
                min: 0
                max: 23
                tickCount: 10
                labelFormat: "%i"
            }
        }
    }
}
