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
        contentHeight: chartsColumn.height
        clip: true

        ColumnLayout {
            id: chartsColumn
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top

            //============================================================================================================
            ChartView {
                id: chartView
                Layout.preferredHeight: flickable.height / 2
                Layout.fillWidth: true

                animationDuration: engine.simulationSpeed
                animationOptions: settings.animated ? ChartView.SeriesAnimations : ChartView.NoAnimation
                animationEasingCurve.type: Easing.Linear
                legend.visible: true
                legend.alignment: Qt.AlignBottom

                antialiasing: settings.antiAliasing
                theme: ChartView.ChartThemeDark

                ValueAxis {
                    id: timeAxis
                    min: 0
                    max: 23
                    tickCount: 12
                    labelFormat: "%i"
                }

                ValueAxis {
                    id: priceAxis
                    min: -4
                    max: 15
                    titleText: "Preis [cent/kWh]"
                    gridVisible: false
                    labelFormat: "%i"
                }

                // -------------------------------------------------------------------
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
                            target: engine.getHoushold(1)
                            onUpdated: {
                                networkPriceSeries.dataSeries = engine.getHoushold(1).getDataSeries(engine.currentIteration, "Netzpreis [€/kWh]")
                                //networkPriceSeries.append(0,0)
                            }
                        }

                        property QtObject dataSeries: null

                        Connections {
                            target: networkPriceSeries.dataSeries
                            onDataChanged: {
                                networkPriceSeries.append(x, y * 100)
                            }
                        }

                        Connections {
                            target: engine
                            onReset: networkPriceSeries.clear()
                            onCurrentIterationChanged: {
                                networkPriceSeries.dataSeries = engine.getHoushold(1).getDataSeries(engine.currentIteration, "Netzpreis [€/kWh]")
                            }
                        }
                    }

                    lowerSeries: LineSeries {
                        id: networkPriceLowerSeries

                        Connections {
                            target: engine.getHoushold(1)
                            onUpdated: {
                                networkPriceLowerSeries.dataSeries = engine.getHoushold(1).getDataSeries(engine.currentIteration, "Netzpreis [€/kWh]")
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
                            onCurrentIterationChanged: {
                                networkPriceLowerSeries.dataSeries = engine.getHoushold(1).getDataSeries(engine.currentIteration, "Netzpreis [€/kWh]")
                            }
                        }
                    }
                }


                // -------------------------------------------------------------------
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
                            target: engine.getHoushold(1)
                            onUpdated: {
                                energyPriceSummSeries.dataSeries = engine.getHoushold(1).getDataSeries(engine.currentIteration, "Bezugspreis Brutto [€/kWh]")
                                //energyPriceSummSeries.append(0,0)
                            }
                        }

                        property QtObject dataSeries: null

                        Connections {
                            target: energyPriceSummSeries.dataSeries
                            onDataChanged: {
                                energyPriceSummSeries.append(x, y * 100)
                            }
                        }

                        Connections {
                            target: engine
                            onReset: energyPriceSummSeries.clear()
                            onCurrentIterationChanged: energyPriceSummSeries.dataSeries = engine.getHoushold(1).getDataSeries(engine.currentIteration, "Bezugspreis Brutto [€/kWh]")
                        }
                    }

                    lowerSeries: LineSeries {
                        id: energyPriceLowerSeries

                        Connections {
                            target: engine.getHoushold(1)
                            onUpdated: {
                                energyPriceLowerSeries.dataSeries = engine.getHoushold(1).getDataSeries(engine.currentIteration, "Netzpreis [€/kWh]")
                                //energyPriceLowerSeries.append(0,0)
                            }
                        }

                        property QtObject dataSeries: null

                        Connections {
                            target: energyPriceLowerSeries.dataSeries
                            onDataChanged: {
                                energyPriceLowerSeries.append(x, y * 100)
                            }
                        }

                        Connections {
                            target: engine
                            onReset: energyPriceLowerSeries.clear()
                            onCurrentIterationChanged: {
                                energyPriceLowerSeries.dataSeries = engine.getHoushold(1).getDataSeries(engine.currentIteration, "Netzpreis [€/kWh]")
                            }
                        }
                    }
                }



                // -------------------------------------------------------------------
                // Einspeisetarif [€/kWh] (Column V)
                LineSeries {
                    id: einspeiseTarifSeries
                    name: "Einspeisetarif"
                    axisX: timeAxis
                    axisY: priceAxis

                    Connections {
                        target: engine.getHoushold(1)
                        onUpdated: {
                            einspeiseTarifSeries.dataSeries = engine.getHoushold(1).getDataSeries(engine.currentIteration, "Einspeisetarif [€/kWh]")
                            //einspeiseTarifSeries.append(0,0)
                        }
                    }

                    property QtObject dataSeries: null

                    Connections {
                        target: einspeiseTarifSeries.dataSeries
                        onDataChanged: {
                            einspeiseTarifSeries.append(x, y * 100)
                        }
                    }

                    Connections {
                        target: engine
                        onReset: einspeiseTarifSeries.clear()
                        onCurrentIterationChanged: {
                            einspeiseTarifSeries.dataSeries = engine.getHoushold(1).getDataSeries(engine.currentIteration, "Einspeisetarif [€/kWh]")
                        }
                    }
                }

                // -------------------------------------------------------------------
                // "Bezugspreis Brutto [€/kWh]" (Column U + T)
                LineSeries {
                    id: bezugspreisBruttoSeries
                    name: "Bezugspreis Brutto"
                    axisX: timeAxis
                    axisY: priceAxis

                    width: 3
                    color: "red"

                    Connections {
                        target: engine.getHoushold(1)
                        onUpdated: {
                            bezugspreisBruttoSeries.dataSeries = engine.getHoushold(1).getDataSeries(engine.currentIteration, "Bezugspreis Brutto [€/kWh]")
                            //bezugspreisBruttoSeries.append(0,0)
                        }
                    }

                    property QtObject dataSeries: null

                    Connections {
                        target: bezugspreisBruttoSeries.dataSeries
                        onDataChanged: {
                            bezugspreisBruttoSeries.append(x, y * 100)
                        }
                    }

                    Connections {
                        target: engine
                        onReset: bezugspreisBruttoSeries.clear()
                        onCurrentIterationChanged: {
                            bezugspreisBruttoSeries.dataSeries = engine.getHoushold(1).getDataSeries(engine.currentIteration, "Bezugspreis Brutto [€/kWh]")
                        }
                    }
                }
            }


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

                antialiasing: settings.antiAliasing

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

                    property QtObject dataSeries: engine.getGridDataSeries(engine.currentIteration)

                    Connections {
                        target: gesamtverbrauchSeries.dataSeries
                        onDataChanged: {
                            gesamtverbrauchSeries.append(x, y)
                        }
                    }

                    Connections {
                        target: engine
                        onReset: gesamtverbrauchSeries.clear()
                        onInitialized: gesamtverbrauchSeries.dataSeries = engine.getGridDataSeries(engine.currentIteration)
                        onCurrentIterationChanged: {
                            gesamtverbrauchSeries.dataSeries = engine.getGridDataSeries(engine.currentIteration)
                        }
                    }
                }
            }
        }
    }
}

