import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3
import QtCharts 2.2

Page {
    id: root

    ColumnLayout {

        anchors.fill: parent

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
                    text: settings.host
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

            }

        }

        RowLayout {
            id: buttonRow
            Layout.fillWidth: true

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
                    settings.host = nymeaHostTextField.text
                    print("Settings: host = " + settings.host)

                    settings.simulationSpeed = simulationSpeedTextField.value
                    print("Settings: simulationSpeed = " + settings.simulationSpeed)

                    settings.fullscreen = fullscreenCheckBox.checked
                    print("Settings: fullscreen = " + settings.fullscreen)

                    stackView.pop()
                }
            }

        }
    }
}
