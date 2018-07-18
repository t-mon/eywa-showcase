#include <QApplication>
#include <QQmlApplicationEngine>

#include "engine.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);

    qmlRegisterType<Engine>("Eywa", 1, 0, "Engine");
    qmlRegisterUncreatableType<Houshold>("Eywa", 1, 0, "Houshold", "Get it from the engine");
    qmlRegisterUncreatableType<DataSeries>("Eywa", 1, 0, "DataSeries", "Get it from the houshold");
    qmlRegisterUncreatableType<DataManager>("Eywa", 1, 0, "DataManager", "Get it from the engine");
    qmlRegisterUncreatableType<LogEntriesProxy>("Eywa", 1, 0, "LogEntriesProxy", "Get it from the houshold");
    qmlRegisterUncreatableType<Block>("Eywa", 1, 0, "Block", "Get it from the engine");
    qmlRegisterUncreatableType<Blocks>("Eywa", 1, 0, "Blocks", "Get it from the engine");
    qmlRegisterUncreatableType<BlocksProxy>("Eywa", 1, 0, "BlocksProxy", "Get it from the engine");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
