import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtCharts 2.2

Page {
    id: root


    Flickable {
        id: flickable
        anchors.fill: parent
        anchors.bottomMargin: buttonRow.height
        contentHeight: chartsColumn.height
        clip: true

        ColumnLayout {
            id: chartsColumn
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top


            Item  {
                id: settingsItem
                Layout.fillHeight: true
                Layout.fillWidth: true

                GridLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    columnSpacing: 10
                    rowSpacing: 10
                    columns: 3

                    Label { text: "Nymea host:" }

                    TextField {
                        id: nymeaHostTextField
                        Layout.fillWidth: true
                        Layout.columnSpan: 2
                        text: settings.nymeaHost
                    }


                    Label { text: "Optimizer host:" }

                    TextField {
                        id: optimizerHostTextField
                        Layout.fillWidth: true
                        Layout.columnSpan: 2
                        text: settings.optimizerHost
                    }

                    Label { text: "Simulation speed:" }
                    Label { text: Math.round(simulationSpeedTextField.value) + " [ms]" }
                    Slider {
                        id: simulationSpeedTextField
                        Layout.fillWidth: true
                        from: 100
                        to: 10000
                        value: settings.simulationSpeed
                    }

                    CheckBox {
                        id: fullscreenCheckBox
                        checked: settings.fullscreen
                        text: "Vollbild"
                    }
                    Item {
                        Layout.fillWidth: true;
                        Layout.columnSpan: 2
                    }

                    CheckBox {
                        id: animationCheckBox
                        checked: settings.animated
                        text: "Animationen"
                    }
                    Item {
                        Layout.fillWidth: true;
                        Layout.columnSpan: 2
                    }


                }

            }
        }
    }


    RowLayout {
        id: buttonRow
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Button {
            id: backButton
            text: "Schließen"
            Layout.fillWidth: true
            onClicked: stackView.pop()
        }

        Button {
            id: saveButton
            text: "Speichern"
            Layout.fillWidth: true
            onClicked: {
                settings.nymeaHost = nymeaHostTextField.text
                print("Settings: nymea host = " + settings.nymeaHost)

                settings.optimizerHost = optimizerHostTextField.text
                print("Settings: optimizer host = " + settings.optimizerHost)

                settings.simulationSpeed = simulationSpeedTextField.value
                print("Settings: simulationSpeed = " + settings.simulationSpeed)

                settings.fullscreen = fullscreenCheckBox.checked
                print("Settings: fullscreen = " + settings.fullscreen)

                settings.animated = animationCheckBox.checked
                print("Settings: animated = " + settings.animated)


                stackView.pop()
            }
        }

    }
}
