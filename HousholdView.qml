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




            ChartView {
                id: chartView
                Layout.preferredHeight: flickable.height / 2
                Layout.fillWidth: true

                animationDuration: engine.simulationSpeed
                    animationOptions: ChartView.SeriesAnimations
                animationEasingCurve.type: Easing.Linear

                legend.visible: true
                legend.alignment: Qt.AlignBottom

                theme: ChartView.ChartThemeDark

                //                antialiasing: true

                ValueAxis {
                    id: timeAxis
                    min: 0
                    max: 23
                    tickCount: 10
                    labelFormat: "%i"
                }

                ValueAxis {
                    id: priceAxis
                    min: -5
                    max: 20
                    titleText: "Preis [€/kWh]"
                    gridVisible: false
                    labelFormat: "%i"
                }

                // "Netzpreis [€/kWh]"
                AreaSeries {
                    id: networkPriceArea
                    name: "Netzpreis"
                    axisX: timeAxis
                    axisY: priceAxis
                    opacity: 0.5
                    upperSeries: LineSeries {
                        id: networkPriceSeries

                        Connections {
                            target: houshold
                            onUpdated: {
                                networkPriceSeries.dataSeries = houshold.getDataSeries(1, "Netzpreis [€/kWh]")
                                //networkPriceSeries.append(0,0)
                            }
                        }

                        property QtObject dataSeries: null

                        Connections {
                            target: networkPriceSeries.dataSeries
                            onDataChanged: {
                                networkPriceSeries.append(x, y)
                            }
                        }

                        Connections {
                            target: engine
                            onReset: networkPriceSeries.clear()
                        }
                    }

                    lowerSeries: LineSeries {
                        id: networkPriceLowerSeries

                        Connections {
                            target: houshold
                            onUpdated: {
                                networkPriceLowerSeries.dataSeries = houshold.getDataSeries(1, "Netzpreis [€/kWh]")
                                //networkPriceLowerSeries.append(0,0)
                            }
                        }

                        property QtObject dataSeries: null

                        Connections {
                            target: networkPriceLowerSeries.dataSeries
                            onDataChanged: {
                                networkPriceLowerSeries.append(x, 0)
                            }
                        }

                        Connections {
                            target: engine
                            onReset: networkPriceLowerSeries.clear()
                        }
                    }
                }


                // Energiepreis [€/kWh]
                AreaSeries {
                    id: energyPriceArea
                    name: "Energiepreis"
                    axisX: timeAxis
                    axisY: priceAxis
                    opacity: 0.5

                    upperSeries: LineSeries {
                        id: energyPriceSummSeries

                        Connections {
                            target: houshold
                            onUpdated: {
                                energyPriceSummSeries.dataSeries = houshold.getDataSeries(1, "Bezugspreis Brutto [€/kWh]")
                                //energyPriceSummSeries.append(0,0)
                            }
                        }

                        property QtObject dataSeries: null

                        Connections {
                            target: energyPriceSummSeries.dataSeries
                            onDataChanged: {
                                energyPriceSummSeries.append(x, y)
                            }
                        }

                        Connections {
                            target: engine
                            onReset: energyPriceSummSeries.clear()
                        }
                    }

                    lowerSeries: LineSeries {
                        id: energyPriceLowerSeries

                        Connections {
                            target: houshold
                            onUpdated: {
                                energyPriceLowerSeries.dataSeries = houshold.getDataSeries(1, "Netzpreis [€/kWh]")
                                energyPriceLowerSeries.append(0,0)
                            }
                        }

                        property QtObject dataSeries: null

                        Connections {
                            target: energyPriceLowerSeries.dataSeries
                            onDataChanged: {
                                energyPriceLowerSeries.append(x, y)
                            }
                        }

                        Connections {
                            target: engine
                            onReset: energyPriceLowerSeries.clear()
                        }
                    }
                }



                // Einspeisetarif [€/kWh] (Column V)
                LineSeries {
                    id: einspeiseTarifSeries
                    name: "Einspeisetarif"
                    axisX: timeAxis
                    axisY: priceAxis

                    Connections {
                        target: houshold
                        onUpdated: {
                            einspeiseTarifSeries.dataSeries = houshold.getDataSeries(1, "Einspeisetarif [€/kWh]")
                            //einspeiseTarifSeries.append(0,0)
                        }
                    }

                    property QtObject dataSeries: null

                    Connections {
                        target: einspeiseTarifSeries.dataSeries
                        onDataChanged: {
                            einspeiseTarifSeries.append(x, y)
                        }
                    }

                    Connections {
                        target: engine
                        onReset: einspeiseTarifSeries.clear()
                    }
                }

                // "Bezugspreis Brutto [€/kWh]" (Column U + T)
                LineSeries {
                    id: bezugspreisBruttoSeries
                    name: "Bezugspreis Brutto"
                    axisX: timeAxis
                    axisY: priceAxis

                    width: 3
                    color: "red"

                    Connections {
                        target: houshold
                        onUpdated: {
                            bezugspreisBruttoSeries.dataSeries = houshold.getDataSeries(1, "Bezugspreis Brutto [€/kWh]")
                            //bezugspreisBruttoSeries.append(0,0)
                        }
                    }

                    property QtObject dataSeries: null

                    Connections {
                        target: bezugspreisBruttoSeries.dataSeries
                        onDataChanged: {
                            bezugspreisBruttoSeries.append(x, y)
                        }
                    }

                    Connections {
                        target: engine
                        onReset: bezugspreisBruttoSeries.clear()
                    }
                }
            }







            ChartView {
                id: chartView2
                Layout.preferredHeight: flickable.height / 2
                Layout.fillWidth: true

                legend.visible: true
                legend.alignment: Qt.AlignBottom

                theme: ChartView.ChartThemeDark

                ValueAxis {
                    id: energyAxis
                    min: -4
                    max: 18
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



                AreaSeries {
                    id: pvArea
                    name: "PV-Produktion"
                    axisX: timeAxis2
                    axisY: energyAxis
                    opacity: 0.5
                    upperSeries: LineSeries {
                        id: pvSeries

                        Connections {
                            target: houshold
                            onUpdated: {
                                pvSeries.dataSeries = houshold.getDataSeries(1, "PV-Produktion [kW]")
                                //networkPriceSeries.append(0,0)
                            }
                        }

                        property QtObject dataSeries: null

                        Connections {
                            target: pvSeries.dataSeries
                            onDataChanged: {
                                pvSeries.append(x, y)
                            }
                        }

                        Connections {
                            target: engine
                            onReset: pvSeries.clear()
                        }
                    }

                    lowerSeries: LineSeries {
                        id: pvLowerSeries

                        Connections {
                            target: houshold
                            onUpdated: {
                                pvLowerSeries.dataSeries = houshold.getDataSeries(1, "PV-Produktion [kW]")
                                //networkPriceLowerSeries.append(0,0)
                            }
                        }

                        property QtObject dataSeries: null

                        Connections {
                            target: pvLowerSeries.dataSeries
                            onDataChanged: {
                                pvLowerSeries.append(x, 0)
                            }
                        }

                        Connections {
                            target: engine
                            onReset: pvLowerSeries.clear()
                        }
                    }
                }


                AreaSeries {
                    id: housholdArea
                    name: "Nicht steuerbar"
                    axisX: timeAxis2
                    axisY: energyAxis
                    opacity: 0.5
                    upperSeries: LineSeries {
                        id: housholdSeries

                        Connections {
                            target: houshold
                            onUpdated: {
                                housholdSeries.dataSeries = houshold.getDataSeries(1, "Nicht steuerbar [kW]")
                                //networkPriceSeries.append(0,0)
                            }
                        }

                        property QtObject dataSeries: null

                        Connections {
                            target: housholdSeries.dataSeries
                            onDataChanged: {
                                housholdSeries.append(x, y)
                            }
                        }

                        Connections {
                            target: engine
                            onReset: housholdSeries.clear()
                        }
                    }

                    lowerSeries: LineSeries {
                        id: housholdLowerSeries

                        Connections {
                            target: houshold
                            onUpdated: {
                                housholdLowerSeries.dataSeries = houshold.getDataSeries(1, "Nicht steuerbar [kW]")
                                //networkPriceLowerSeries.append(0,0)
                            }
                        }

                        property QtObject dataSeries: null

                        Connections {
                            target: housholdLowerSeries.dataSeries
                            onDataChanged: {
                                housholdLowerSeries.append(x, 0)
                            }
                        }

                        Connections {
                            target: engine
                            onReset: housholdLowerSeries.clear()
                        }
                    }
                }




                // E-car
                AreaSeries {
                    id: housholdCarArea
                    name: "E-Auto"
                    axisX: timeAxis2
                    axisY: energyAxis
                    opacity: 0.5
                    upperSeries: LineSeries {
                        id: housholdCarSeries

                        Connections {
                            target: houshold
                            onUpdated: {
                                housholdCarSeries.dataSeries = houshold.getDataSeries(1, "houshold + ecar")
                                //networkPriceSeries.append(0,0)
                            }
                        }

                        property QtObject dataSeries: null

                        Connections {
                            target: housholdCarSeries.dataSeries
                            onDataChanged: {
                                housholdCarSeries.append(x, y)
                            }
                        }

                        Connections {
                            target: engine
                            onReset: housholdCarSeries.clear()
                        }
                    }

                    lowerSeries: LineSeries {
                        id: housholdCarLowerSeries

                        Connections {
                            target: houshold
                            onUpdated: {
                                housholdCarLowerSeries.dataSeries = houshold.getDataSeries(1, "Nicht steuerbar [kW]")
                                //networkPriceSeries.append(0,0)
                            }
                        }

                        property QtObject dataSeries: null

                        Connections {
                            target: housholdCarLowerSeries.dataSeries
                            onDataChanged: {
                                housholdCarLowerSeries.append(x, y)
                            }
                        }

                        Connections {
                            target: engine
                            onReset: housholdCarLowerSeries.clear()
                        }
                    }
                }





                // Battery
                AreaSeries {
                    id: housholdCarBatteryArea
                    name: "Batterie"
                    axisX: timeAxis2
                    axisY: energyAxis
                    opacity: 0.5
                    upperSeries: LineSeries {
                        id: housholdCarBatterySeries

                        Connections {
                            target: houshold
                            onUpdated: {
                                housholdCarBatterySeries.dataSeries = houshold.getDataSeries(1, "houshold + ecar + battery")
                                //networkPriceSeries.append(0,0)
                            }
                        }

                        property QtObject dataSeries: null

                        Connections {
                            target: housholdCarBatterySeries.dataSeries
                            onDataChanged: {
                                housholdCarBatterySeries.append(x, y)
                            }
                        }

                        Connections {
                            target: engine
                            onReset: housholdCarBatterySeries.clear()
                        }
                    }

                    lowerSeries: LineSeries {
                        id: housholdCarBatteryLowerSeries

                        Connections {
                            target: houshold
                            onUpdated: {
                                housholdCarBatteryLowerSeries.dataSeries = houshold.getDataSeries(1, "houshold + ecar")
                                //networkPriceSeries.append(0,0)
                            }
                        }

                        property QtObject dataSeries: null

                        Connections {
                            target: housholdCarBatteryLowerSeries.dataSeries
                            onDataChanged: {
                                housholdCarBatteryLowerSeries.append(x, y)
                            }
                        }

                        Connections {
                            target: engine
                            onReset: housholdCarBatteryLowerSeries.clear()
                        }
                    }
                }


                // "Gesamtverbrauch [kW]" (Column W)
                LineSeries {
                    id: gesamtverbrauchSeries
                    name: "Gesamtverbrauch"
                    axisX: timeAxis2
                    axisY: energyAxis

                    width: 3
                    color: "red"

                    Connections {
                        target: houshold
                        onUpdated: {
                            gesamtverbrauchSeries.dataSeries = houshold.getDataSeries(1, "Gesamtverbrauch [kW]")
                        }
                    }

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
                    }
                }
            }



            ChartView {
                id: chartView3
                Layout.preferredHeight: flickable.height / 2
                Layout.fillWidth: true

                legend.visible: true
                legend.alignment: Qt.AlignBottom

                theme: ChartView.ChartThemeDark

            }
        }
    }
}
