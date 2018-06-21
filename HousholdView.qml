import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtCharts 2.2

Item {
    id: root

    property int housholdNumber: 0

    property QtObject houshold: engine.getHoushold(housholdNumber)
    property string name: houshold.name

    Connections {
        target: houshold
        onReseted: {
            chartView.update()
            chartView2.update()
        }
    }

    ColumnLayout {
        id: chartsColumn
        anchors.fill: parent

        ChartView {
            id: chartView
            Layout.fillHeight: true
            Layout.fillWidth: true

            animationDuration: settings.simulationSpeed
            animationOptions: ChartView.SeriesAnimations
            animationEasingCurve.type: Easing.Linear

            legend.visible: true
            legend.alignment: Qt.AlignBottom

            theme: ChartView.ChartThemeDark

            antialiasing: true

            ValueAxis {
                id: timeAxis
                min: 0
                max: 24
                tickCount: 10
                labelFormat: "%i"
            }

            // *********************************************************************
            ValueAxis {
                id: deviceState
                min: -200
                max: 200
                titleText: "Status"
                gridVisible: false
                labelFormat: "%i"
            }


            // Status battery
            LineSeries {
                id: statusBatterySeries

                Connections {
                    target: houshold
                    onUpdated: {
                        statusBatterySeries.dataSeries = houshold.getDataSeries(1, "Zeitslot")
                        dataConnection.target = dataSeries

                    }
                }

                property QtObject dataSeries: houshold.getDataSeries(1, "Zeitslot")

                Connections {
                    id: dataConnection
                    target: dataSeries
                    onDataChanged: {
                        console.log("x = " + x + " | y = " + y)
                        statusBatterySeries.append(x, y)
                        print("----------------")
                    }
                }

                Connections {
                    target: engine
                    onReset: statusBatterySeries.clear()
                }

                name: dataSeries.name
                axisX: timeAxis
                axisY: deviceState

                Component.onCompleted: statusBatterySeries.append(0,0)
            }




//            // E Car
//            LineSeries {
//                id: timeSeries

//                property QtObject dataSeries: houshold.getDataSeries(1, "Zeitslot")

//                Connections {
//                    target: houshold.getDataSeries(statusWPSeries.columnNumber)
//                    onDataChanged: {
//                        console.log("x = " + x + " | y = " + y)
//                        statusWPSeries.append(x, y)
//                    }
//                }

//                Connections {
//                    target: dataSeries
//                    onDataChanged: {
//                        console.log("x = " + x + " | y = " + y)
//                        ecarSeries.append(x, y)
//                    }
//                }

//                Connections {
//                    target: engine
//                    onReset: timeSeries.clear()
//                }

//                name: dataSeries.name
//                axisX: timeAxis
//                axisY: deviceState

//                Component.onCompleted: timeSeries.append(0,0)
//            }

            //            // Status WP
            //            LineSeries {
            //                id: statusWPSeries

            //                property int columnNumber: 13
            //                property QtObject dataSeries: houshold.getDataSeries(1, "Zeitslot")

            //                Connections {
            //                    target: houshold.getDataSeries(statusWPSeries.columnNumber)
            //                    onDataChanged: {
            //                        console.log("x = " + x + " | y = " + y)
            //                        statusWPSeries.append(x, y)
            //                    }
            //                }

            //                Connections {
            //                    target: engine
            //                    onReset: statusWPSeries.clear()
            //                }

            //                name: dataSeries.name
            //                axisX: timeAxis
            //                axisY: deviceState

            //                Component.onCompleted: statusWPSeries.append(0,0)
            //            }


            //            // *********************************************************************
            //            // Costs
            //            ValueAxis {
            //                id: costsAxis
            //                min: 0
            //                max: 30
            //                gridVisible: false
            //                titleText: "€"
            //                labelFormat: "%i"
            //            }

            //            // Energy costs
            //            LineSeries {
            //                id: energyCostsSeries

            //                property int columnNumber: 15
            //                property QtObject dataSeries: houshold.getDataSeries(columnNumber)

            //                Connections {
            //                    target: houshold.getDataSeries(energyCostsSeries.columnNumber)
            //                    onDataChanged: {
            //                        console.log("x = " + x + " | y = " + y)
            //                        energyCostsSeries.append(x, y)
            //                    }
            //                }

            //                Connections {
            //                    target: engine
            //                    onReset: energyCostsSeries.clear()
            //                }

            //                name: dataSeries.name
            //                axisX: timeAxis
            //                axisYRight: costsAxis

            //                Component.onCompleted: energyCostsSeries.append(0,0)
            //            }

            //            // Netzpreis
            //            LineSeries {
            //                id: networkPriceSeries

            //                property int columnNumber: 18
            //                property QtObject dataSeries: houshold.getDataSeries(columnNumber)

            //                Connections {
            //                    target: houshold.getDataSeries(networkPriceSeries.columnNumber)
            //                    onDataChanged: {
            //                        console.log("x = " + x + " | y = " + y)
            //                        networkPriceSeries.append(x, y)
            //                    }
            //                }

            //                Connections {
            //                    target: engine
            //                    onReset: networkPriceSeries.clear()
            //                }

            //                name: dataSeries.name
            //                axisX: timeAxis
            //                axisYRight: costsAxis

            //                Component.onCompleted: networkPriceSeries.append(0, dataSeries.getValueAt(0))
            //            }

            //            // Energie preis
            //            LineSeries {
            //                id: energyPriceSeries

            //                property int columnNumber: 19
            //                property QtObject dataSeries: houshold.getDataSeries(columnNumber)

            //                Connections {
            //                    target: houshold.getDataSeries(energyPriceSeries.columnNumber)
            //                    onDataChanged: {
            //                        console.log("x = " + x + " | y = " + y)
            //                        energyPriceSeries.append(x, y)
            //                    }
            //                }

            //                Connections {
            //                    target: engine
            //                    onReset: energyPriceSeries.clear()
            //                }

            //                name: dataSeries.name
            //                axisX: timeAxis
            //                axisYRight: costsAxis

            //                Component.onCompleted: energyPriceSeries.append(0, dataSeries.getValueAt(0))
            //            }

        }

        //        ChartView {
        //            id: chartView2
        //            Layout.fillHeight: true
        //            Layout.fillWidth: true

        //            animationDuration: settings.simulationSpeed
        //            animationOptions: ChartView.SeriesAnimations
        //            animationEasingCurve.type: Easing.Linear

        //            theme: ChartView.ChartThemeDark

        //            legend.visible: true
        //            legend.alignment: Qt.AlignBottom

        //            antialiasing: true

        //            ValueAxis {
        //                id: timeAxis2
        //                min: 0
        //                max: 24
        //                tickCount: 10
        //                labelFormat: "%i"
        //            }

        //            // *********************************************************************
        //            ValueAxis {
        //                id: temperatureAxis
        //                min: 0
        //                max: 50
        //                titleText: "Temperature [°C]"
        //                gridVisible: false
        //            }


        //            // Außentemperatur
        //            LineSeries {
        //                id: outsideTemperatureSeries

        //                property int columnNumber: 1
        //                property QtObject dataSeries: houshold.getDataSeries(1, "Zeitslot")

        //                Connections {
        //                    target: houshold.getDataSeries(outsideTemperatureSeries.columnNumber)
        //                    onDataChanged: {
        //                        console.log("x = " + x + " | y = " + y)
        //                        outsideTemperatureSeries.append(x, y)
        //                    }
        //                }

        //                Connections {
        //                    target: engine
        //                    onReset: outsideTemperatureSeries.clear()
        //                }

        //                name: dataSeries.name
        //                axisX: timeAxis2
        //                axisY: temperatureAxis

        //                Component.onCompleted: outsideTemperatureSeries.append(0, dataSeries.getValueAt(0))
        //            }



        //            AreaSeries {

        //                name: "Temperatur Bereich"

        //                upperSeries: LineSeries {
        //                    id: minSeries


        //                    property int columnNumber: 8
        //                    property QtObject dataSeries: houshold.getDataSeries(columnNumber)

        //                    Connections {
        //                        target: houshold.getDataSeries(minSeries.columnNumber)
        //                        onDataChanged: {
        //                            console.log("x = " + x + " | y = " + y)
        //                            minSeries.append(x, y)
        //                        }
        //                    }

        //                    Connections {
        //                        target: engine
        //                        onReset: minSeries.clear()
        //                    }

        //                    name: dataSeries.name
        //                    axisX: timeAxis2
        //                    axisY: temperatureAxis

        //                    Component.onCompleted: minSeries.append(0, dataSeries.getValueAt(0))
        //                }

        //                lowerSeries: LineSeries {
        //                    id: maxSeries

        //                    property int columnNumber: 9
        //                    property QtObject dataSeries: houshold.getDataSeries(columnNumber)

        //                    Connections {
        //                        target: houshold.getDataSeries(maxSeries.columnNumber)
        //                        onDataChanged: {
        //                            console.log("x = " + x + " | y = " + y)
        //                            maxSeries.append(x, y)
        //                        }
        //                    }

        //                    Connections {
        //                        target: engine
        //                        onReset: maxSeries.clear()
        //                    }

        //                    name: dataSeries.name
        //                    axisX: timeAxis2
        //                    axisY: temperatureAxis

        //                    Component.onCompleted: maxSeries.append(0, dataSeries.getValueAt(0))
        //                }
        //            }

        //            LineSeries {
        //                id: istSeries

        //                property int columnNumber: 16
        //                property QtObject dataSeries: houshold.getDataSeries(columnNumber)

        //                Connections {
        //                    target: houshold.getDataSeries(istSeries.columnNumber)
        //                    onDataChanged: {
        //                        console.log("x = " + x + " | y = " + y)
        //                        istSeries.append(x, y)
        //                    }
        //                }

        //                Connections {
        //                    target: engine
        //                    onReset: istSeries.clear()
        //                }

        //                name: dataSeries.name
        //                axisX: timeAxis2
        //                axisY: temperatureAxis

        //                Component.onCompleted: istSeries.append(0, dataSeries.getValueAt(0))
        //            }



        ////            // *********************************************************************
        ////            ValueAxis {
        ////                id: percentageAxis
        ////                min: 0
        ////                max: 100
        ////                titleText: "Mobility [%]"
        ////                gridVisible: false
        ////            }


        ////            AreaSeries {

        ////                name: "Mobility Bereich"

        ////                upperSeries: LineSeries {
        ////                    id: minMobilitySeries


        ////                    property int columnNumber: 6
        ////                    property QtObject dataSeries: houshold.getDataSeries(columnNumber)

        ////                    Connections {
        ////                        target: houshold.getDataSeries(minMobilitySeries.columnNumber)
        ////                        onDataChanged: {
        ////                            console.log("x = " + x + " | y = " + y)
        ////                            minMobilitySeries.append(x, y)
        ////                        }
        ////                    }

        ////                    Connections {
        ////                        target: engine
        ////                        onReset: minMobilitySeries.clear()
        ////                    }

        ////                    name: dataSeries.name
        ////                    axisX: timeAxis2
        ////                    axisYRight: percentageAxis

        ////                    Component.onCompleted: minMobilitySeries.append(0, dataSeries.getValueAt(0))
        ////                }

        ////                lowerSeries: LineSeries {
        ////                    id: maxMobilitySeries

        ////                    property int columnNumber: 7
        ////                    property QtObject dataSeries: houshold.getDataSeries(columnNumber)

        ////                    Connections {
        ////                        target: houshold.getDataSeries(maxMobilitySeries.columnNumber)
        ////                        onDataChanged: {
        ////                            console.log("x = " + x + " | y = " + y)
        ////                            maxMobilitySeries.append(x, y)
        ////                        }
        ////                    }

        ////                    Connections {
        ////                        target: engine
        ////                        onReset: maxMobilitySeries.clear()
        ////                    }

        ////                    name: dataSeries.name
        ////                    axisX: timeAxis2
        ////                    axisYRight: percentageAxis

        ////                    Component.onCompleted: maxMobilitySeries.append(0, dataSeries.getValueAt(0))
        ////                }
        ////            }



        ////            LineSeries {
        ////                id: istMobilitySeries

        ////                property int columnNumber: 17
        ////                property QtObject dataSeries: houshold.getDataSeries(columnNumber)

        ////                Connections {
        ////                    target: houshold.getDataSeries(istMobilitySeries.columnNumber)
        ////                    onDataChanged: {
        ////                        console.log("x = " + x + " | y = " + y)
        ////                        istMobilitySeries.append(x, y)
        ////                    }
        ////                }

        ////                Connections {
        ////                    target: engine
        ////                    onReset: istMobilitySeries.clear()
        ////                }

        ////                name: dataSeries.name
        ////                axisX: timeAxis2
        ////                axisYRight: percentageAxis

        ////                Component.onCompleted: istMobilitySeries.append(0, dataSeries.getValueAt(0))
        ////            }
        //        }
    }
}
