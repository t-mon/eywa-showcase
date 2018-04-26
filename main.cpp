#include <QApplication>
#include <QQmlApplicationEngine>

#include "engine.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);

    qmlRegisterType<Engine>("Eywa", 1, 0, "Engine");
    qmlRegisterUncreatableType<Houshold>("Eywa", 1, 0, "Houshold", "Get it form the engine");
    qmlRegisterUncreatableType<DataSeries>("Eywa", 1, 0, "DataSeries", "Get it form the houshold");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}