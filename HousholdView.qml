import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtCharts 2.2

Item {
    id: root

    property int housholdNumber: 0
    property int currentIterationNumber: engine.currentIteration


    property QtObject houshold: engine.getHoushold(housholdNumber)
    property string name: houshold.name

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

            RowLayout {
                Layout.fillWidth: true

                Button {
                    Layout.fillWidth: true
                    text: "Logs"
                    onClicked: stackView.push(Qt.resolvedUrl("LogsPage.qml"))
                }
            }


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

                theme: ChartView.ChartThemeDark

                //                antialiasing: true

                ValueAxis {
                    id: timeAxis
                    min: 0
                    max: 24
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
                            target: houshold
                            onUpdated: {
                                networkPriceSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Netzpreis [€/kWh]")
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
                                networkPriceSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Netzpreis [€/kWh]")
                            }
                        }
                    }

                    lowerSeries: LineSeries {
                        id: networkPriceLowerSeries

                        Connections {
                            target: houshold
                            onUpdated: {
                                networkPriceLowerSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Netzpreis [€/kWh]")
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
                                networkPriceLowerSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Netzpreis [€/kWh]")
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
                            target: houshold
                            onUpdated: {
                                energyPriceSummSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Bezugspreis Brutto [€/kWh]")
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
                            onCurrentIterationChanged: energyPriceSummSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Bezugspreis Brutto [€/kWh]")
                        }
                    }

                    lowerSeries: LineSeries {
                        id: energyPriceLowerSeries

                        Connections {
                            target: houshold
                            onUpdated: {
                                energyPriceLowerSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Netzpreis [€/kWh]")
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
                                energyPriceLowerSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Netzpreis [€/kWh]")
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
                        target: houshold
                        onUpdated: {
                            einspeiseTarifSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Einspeisetarif [€/kWh]")
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
                            einspeiseTarifSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Einspeisetarif [€/kWh]")
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
                        target: houshold
                        onUpdated: {
                            bezugspreisBruttoSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Bezugspreis Brutto [€/kWh]")
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
                            bezugspreisBruttoSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Bezugspreis Brutto [€/kWh]")
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

                antialiasing: true

                ValueAxis {
                    id: energyAxis
                    min: -4
                    max: 14
                    titleText: "Energie [kW]"
                    gridVisible: false
                    labelFormat: "%i"
                }

                ValueAxis {
                    id: timeAxis2
                    min: 0
                    max: 23
                    tickCount: 12
                    labelFormat: "%i"
                }


                // -------------------------------------------------------------------
                // PV-Produktion [kW]
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
                                pvSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "PV-Produktion [kW]")
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
                            onCurrentIterationChanged: {
                                pvSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "PV-Produktion [kW]")
                            }
                        }
                    }

                    lowerSeries: LineSeries {
                        id: pvLowerSeries

                        Connections {
                            target: houshold
                            onUpdated: {
                                pvLowerSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "PV-Produktion [kW]")
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
                            onCurrentIterationChanged: {
                                pvLowerSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "PV-Produktion [kW]")
                            }
                        }
                    }
                }


                // -------------------------------------------------------------------
                // Nicht steuerbar [kW]
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
                                housholdSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Nicht steuerbar [kW]")
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
                            onCurrentIterationChanged: {
                                housholdSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Nicht steuerbar [kW]")
                            }
                        }
                    }

                    lowerSeries: LineSeries {
                        id: housholdLowerSeries

                        Connections {
                            target: houshold
                            onUpdated: {
                                housholdLowerSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Nicht steuerbar [kW]")
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
                            onCurrentIterationChanged: {
                                housholdLowerSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Nicht steuerbar [kW]")
                            }
                        }
                    }
                }


                // -------------------------------------------------------------------
                // E-car
                AreaSeries {
                    id: housholdCarArea
                    name: "E-Auto"
                    axisX: timeAxis2
                    axisY: energyAxis
                    opacity: 0.4
                    upperSeries: LineSeries {
                        id: housholdCarSeries

                        Connections {
                            target: houshold
                            onUpdated: {
                                housholdCarSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "houshold + ecar")
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
                            onCurrentIterationChanged: {
                                housholdCarSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "houshold + ecar")
                            }
                        }
                    }

                    lowerSeries: LineSeries {
                        id: housholdCarLowerSeries

                        Connections {
                            target: houshold
                            onUpdated: {
                                housholdCarLowerSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Nicht steuerbar [kW]")
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
                            onCurrentIterationChanged: {
                                housholdCarLowerSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Nicht steuerbar [kW]")
                            }
                        }
                    }
                }


                // -------------------------------------------------------------------
                // Battery
                AreaSeries {
                    id: housholdCarBatteryArea
                    name: "Batterie"
                    axisX: timeAxis2
                    axisY: energyAxis
                    opacity: 0.4
                    upperSeries: LineSeries {
                        id: housholdCarBatterySeries

                        Connections {
                            target: houshold
                            onUpdated: {
                                housholdCarBatterySeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "houshold + ecar + battery")
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
                            onCurrentIterationChanged: {
                                housholdCarBatterySeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "houshold + ecar + battery")
                            }
                        }
                    }

                    lowerSeries: LineSeries {
                        id: housholdCarBatteryLowerSeries

                        Connections {
                            target: houshold
                            onUpdated: {
                                housholdCarBatteryLowerSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "houshold + ecar")
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
                            onCurrentIterationChanged: {
                                housholdCarBatteryLowerSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "houshold + ecar")
                            }
                        }
                    }
                }



                // -------------------------------------------------------------------
                // WP
                AreaSeries {
                    id: housholdCarBatteryWpArea
                    name: "WP"
                    axisX: timeAxis2
                    axisY: energyAxis
                    opacity: 0.4
                    upperSeries: LineSeries {
                        id: housholdCarBatteryWpSeries

                        Connections {
                            target: houshold
                            onUpdated: {
                                housholdCarBatteryWpSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "houshold + ecar + battery + heatpump")
                                //networkPriceSeries.append(0,0)
                            }
                        }

                        property QtObject dataSeries: null

                        Connections {
                            target: housholdCarBatteryWpSeries.dataSeries
                            onDataChanged: {
                                housholdCarBatteryWpSeries.append(x, y)
                            }
                        }

                        Connections {
                            target: engine
                            onReset: housholdCarBatteryWpSeries.clear()
                            onCurrentIterationChanged: {
                                housholdCarBatteryWpSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "houshold + ecar + battery + heatpump")
                            }
                        }
                    }

                    lowerSeries: LineSeries {
                        id: housholdCarBatteryWpLowerSeries

                        Connections {
                            target: houshold
                            onUpdated: {
                                housholdCarBatteryWpLowerSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "houshold + ecar + battery")
                            }
                        }

                        property QtObject dataSeries: null

                        Connections {
                            target: housholdCarBatteryWpLowerSeries.dataSeries
                            onDataChanged: {
                                housholdCarBatteryWpLowerSeries.append(x, y)
                            }
                        }

                        Connections {
                            target: engine
                            onReset: housholdCarBatteryWpLowerSeries.clear()
                            onCurrentIterationChanged: {
                                housholdCarBatteryWpLowerSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "houshold + ecar + battery")
                            }
                        }
                    }
                }


                // -------------------------------------------------------------------
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
                            gesamtverbrauchSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Gesamtverbrauch [kW]")
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
                        onCurrentIterationChanged: {
                            gesamtverbrauchSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Gesamtverbrauch [kW]")
                        }
                    }
                }
            }


            //============================================================================================================
            ChartView {
                id: chartView3
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
                    id: temperatureAxis
                    min: 18
                    max: 25
                    titleText: "Temperatur [°C]"
                    gridVisible: false
                    labelFormat: "%i"
                }

                ValueAxis {
                    id: mobilityAxis
                    min: 0
                    max: 100
                    titleText: "Mobility [%]"
                    gridVisible: false
                    labelFormat: "%i"
                }

                ValueAxis {
                    id: timeAxis3
                    min: 0
                    max: 23
                    tickCount: 12
                    labelFormat: "%i"
                }


                AreaSeries {
                    id: temperatureArea
                    name: "Temperatur Bereich"
                    axisX: timeAxis3
                    axisY: temperatureAxis
                    opacity: 0.5
                    upperSeries: LineSeries {
                        id: temperaturMaxSeries

                        Connections {
                            target: houshold
                            onUpdated: {
                                temperaturMaxSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Max. Sollwert Temperatur [°C]")
                                //networkPriceSeries.append(0,0)
                            }
                        }

                        property QtObject dataSeries: null

                        Connections {
                            target: temperaturMaxSeries.dataSeries
                            onDataChanged: {
                                temperaturMaxSeries.append(x, y)
                            }
                        }

                        Connections {
                            target: engine
                            onReset: temperaturMaxSeries.clear()
                            onCurrentIterationChanged: {
                                temperaturMaxSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Max. Sollwert Temperatur [°C]")
                            }
                        }
                    }

                    lowerSeries: LineSeries {
                        id: temperaturMinSeries

                        Connections {
                            target: houshold
                            onUpdated: {
                                temperaturMinSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Min. Sollwert Temperatur [°C]")
                                //networkPriceSeries.append(0,0)
                            }
                        }

                        property QtObject dataSeries: null

                        Connections {
                            target: temperaturMinSeries.dataSeries
                            onDataChanged: {
                                temperaturMinSeries.append(x, y)
                            }
                        }

                        Connections {
                            target: engine
                            onReset: temperaturMinSeries.clear()
                            onCurrentIterationChanged: {
                                temperaturMinSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Min. Sollwert Temperatur [°C]")
                            }
                        }
                    }
                }




                // -------------------------------------------------------------------
                // Istwert Temperatur [°C]
                LineSeries {
                    id: istTemperaturSeries
                    name: "Ist-Temperatur"
                    axisX: timeAxis3
                    axisY: temperatureAxis

                    width: 3
                    color: "blue"

                    Connections {
                        target: houshold
                        onUpdated: {
                            istTemperaturSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Istwert Temperatur [°C]")
                        }
                    }

                    property QtObject dataSeries: null

                    Connections {
                        target: istTemperaturSeries.dataSeries
                        onDataChanged: {
                            istTemperaturSeries.append(x, y)
                        }
                    }

                    Connections {
                        target: engine
                        onReset: istTemperaturSeries.clear()
                        onCurrentIterationChanged: {
                            istTemperaturSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Istwert Temperatur [°C]")
                        }
                    }
                }

                // -------------------------------------------------------------------
                // Istwert Mobilität [%]
                ScatterSeries {
                    id: mobilitySeries
                    name: "Istwert Mobilität"
                    axisX: timeAxis3
                    axisYRight: mobilityAxis

                    // Nur anzeigen wenn Anwesenheit E-Auto [0/1] auf 1


                    markerSize: 8

                    Connections {
                        target: houshold
                        onUpdated: {
                            mobilitySeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Istwert Mobilität [%]")
                        }
                    }

                    property QtObject dataSeries: null

                    Connections {
                        target: mobilitySeries.dataSeries
                        onDataChanged: {

                            var ecarPresentDataSeries = houshold.getDataSeries(currentIterationNumber, "Anwesenheit E-Auto [0/1]")

                            if (ecarPresentDataSeries.getValue(x) !== 0) {
                                mobilitySeries.append(x, y)
                            }
                        }
                    }

                    Connections {
                        target: engine
                        onReset: mobilitySeries.clear()
                        onCurrentIterationChanged: {
                            mobilitySeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Istwert Mobilität [%]")
                        }
                    }
                }


                // -------------------------------------------------------------------
                // Bereich in dem das eauto da ist
                AreaSeries {
                    id: ecarPresentArea
                    name: "E-Auto Anwesend"
                    axisX: timeAxis3
                    axisY: mobilityAxis
                    opacity: 0.2
                    upperSeries: LineSeries {
                        id: ecarPresentSeries

                        Connections {
                            target: houshold
                            onUpdated: {
                                ecarPresentSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Anwesenheit E-Auto [0/1]")
                                //networkPriceSeries.append(0,0)
                            }
                        }

                        property QtObject dataSeries: null

                        Connections {
                            target: ecarPresentSeries.dataSeries
                            onDataChanged: {
                                if (ecarPresentSeries.dataSeries.getValue(x) !== 0) {
                                    ecarPresentLowerSeries.append(x, 0)
                                    ecarPresentSeries.append(x, 100)
                                }
                            }
                        }

                        Connections {
                            target: engine
                            onReset: ecarPresentSeries.clear()
                            onCurrentIterationChanged: {
                                ecarPresentSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Anwesenheit E-Auto [0/1]")
                            }
                        }
                    }

                    lowerSeries: LineSeries {
                        id: ecarPresentLowerSeries

                        Connections {
                            target: houshold
                            onUpdated: {
                                ecarPresentLowerSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Anwesenheit E-Auto [0/1]")
                                //networkPriceSeries.append(0,0)
                            }
                        }

                        property QtObject dataSeries: null

                        Connections {
                            target: ecarPresentLowerSeries.dataSeries
                            onDataChanged: {
                                if (minMobilitySeries.dataSeries.getValue(x) !== 0) {
                                    ecarPresentLowerSeries.append(x, 0)
                                }
                            }
                        }

                        Connections {
                            target: engine
                            onReset: ecarPresentLowerSeries.clear()
                            onCurrentIterationChanged: {
                                ecarPresentLowerSeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Anwesenheit E-Auto [0/1]")
                            }
                        }
                    }
                }








                // -------------------------------------------------------------------
                // Min. Sollwert Mobilität [%]
                ScatterSeries {
                    id: minMobilitySeries
                    name: "Min Sollwert Mobilität"
                    axisX: timeAxis3
                    axisYRight: mobilityAxis

                    // Nur anzeigen wenn Min. Sollwert Mobilität [%] != 0

                    opacity: 0.4
                    borderWidth: 0
                    markerSize: 10
                    color: "red"

                    Connections {
                        target: houshold
                        onUpdated: {
                            minMobilitySeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Min. Sollwert Mobilität [%]")
                        }
                    }

                    property QtObject dataSeries: null

                    Connections {
                        target: minMobilitySeries.dataSeries
                        onDataChanged: {
                            if (minMobilitySeries.dataSeries.getValue(x) !== 0) {
                                minMobilitySeries.append(x, y)
                            }
                        }
                    }

                    Connections {
                        target: engine
                        onReset: minMobilitySeries.clear()
                        onCurrentIterationChanged: {
                            minMobilitySeries.dataSeries = houshold.getDataSeries(currentIterationNumber, "Min. Sollwert Mobilität [%]")
                        }
                    }
                }
            }
        }
    }
}
