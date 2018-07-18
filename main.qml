import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import Qt.labs.settings 1.0

import Eywa 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 800
    height: 600
    title: qsTr("Eywa")

    header: Label {
        text: "Eywa"
        horizontalAlignment: Text.AlignHCenter
    }

    visibility: settings.fullscreen ? ApplicationWindow.FullScreen : ApplicationWindow.Maximized

    Settings {
        id: settings
        property string nymeaHost: "127.0.0.1"
        property string optimizerHost: "127.0.0.1"
        property int simulationSpeed: 500
        property bool fullscreen: true
        property bool animated: true

        onSimulationSpeedChanged: engine.simulationSpeed = simulationSpeed
        onOptimizerHostChanged: engine.dataManager.hostAddress = settings.optimizerHost
    }

    Engine {
        id: engine

        Component.onCompleted: {
            engine.dataManager.hostAddress = settings.optimizerHost
            engine.simulationSpeed = settings.simulationSpeed
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
    }

    Component.onCompleted: stackView.push(Qt.resolvedUrl("MainPage.qml"))
}
