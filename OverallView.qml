import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtCharts 2.2

import Eywa 1.0

Item {
    id: root

    ChartView {
        id: chartView2
        anchors.fill: parent
        legend.visible: true
        legend.alignment: Qt.AlignBottom

        theme: ChartView.ChartThemeDark

        animationDuration: engine.simulationSpeed
        animationOptions: settings.animated ? ChartView.SeriesAnimations : ChartView.NoAnimation
        animationEasingCurve.type: Easing.Linear

        antialiasing: true

        ValueAxis {
            id: energyAxis
            min: -20
            max: 50
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

        LineSeries {
            id: gesamtverbrauchSeries
            name: "Gesamtverbrauch"
            axisX: timeAxis2
            axisY: energyAxis

            width: 3
            color: "red"

            property QtObject dataSeries: null

            Connections {
                target: gesamtverbrauchSeries.dataSeries
                onDataChanged: {
                    gesamtverbrauchSeries.append(x, y)
                }
            }

            Connections {
                target: engine
                onReset: gesamtverbrauchSeries.clear()
                onCurrentIterationChanged: {
                    gesamtverbrauchSeries.dataSeries = engine.getGridDataSeries(engine.currentIteration)
                }
            }
        }
    }
}

