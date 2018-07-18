#include "datamanager.h"

#include <QFile>
#include <QDebug>
#include <QNetworkReply>
#include <QJsonDocument>

DataManager::DataManager(QObject *parent) : QObject(parent)
{
    m_networkManager = new QNetworkAccessManager(this);


    // curl -XGET http://192.168.0.183:8080/logs

    // logs für jeden haushalt, i info (fett), d debug(normal)

    //    {
    //      "tstp": 1528373936499,
    //      "client": "HH2",
    //      "l": "i",
    //      "msg": "Daily total consumption: 26.53970588235294 kW"
    //    }

    // Iteration 0 (ausgangssituation)
    // 3 Iterationen (für jeden haushalt für jeden tag)

}

QString DataManager::hostAddress() const
{
    return m_hostAddress;
}

void DataManager::setHostAddress(const QString &hostAddress)
{
    qDebug() << "Set host address" << hostAddress;
    m_hostAddress = hostAddress;
    emit hostAddressChanged();
}

int DataManager::port() const
{
    return m_port;
}

void DataManager::setPort(int port)
{
    m_port = port;
    emit portChanged();
}

void DataManager::refresh()
{
    // Dummy data

    //    QVariantList logsList = loadJsonFile(":/data/logs.json").toList();
    //    qDebug() << logsList;
    //    emit logsRefreshed(logsList);

    //    QVariantList resultsList = loadJsonFile(":/data/results.json").toList();
    //    qDebug() << resultsList;
    //    emit resultsRefreshed(resultsList);

    qDebug() << "DataManager: refresh data" << m_hostAddress << m_port;

    QUrl url;
    url.setScheme("http");
    url.setHost(m_hostAddress);
    url.setPort(m_port);

    // Load logs
    url.setPath("/logs");
    QNetworkReply *reply = m_networkManager->get(QNetworkRequest(url));
    connect(reply, &QNetworkReply::finished, this, &DataManager::onLogsReady);

    // Results logs
    url.setPath("/results");
    reply = m_networkManager->get(QNetworkRequest(url));
    connect(reply, &QNetworkReply::finished, this, &DataManager::onResultsReady);

    // Blocks
    // TODO

}

QVariant DataManager::loadJsonFile(const QString &fileName)
{
    QFile file(fileName);
    if (!file.open(QFile::ReadOnly)) {
        qWarning() << "Could not open file" << fileName << file.errorString();
        return QVariant();
    }

    qDebug() << "Load" << fileName;

    QByteArray data = file.readAll();

    QJsonDocument jsonDoc = QJsonDocument::fromJson(data);
    qDebug() << qUtf8Printable(jsonDoc.toJson(QJsonDocument::Indented));

    return jsonDoc.toVariant();
}

void DataManager::onLogsReady()
{
    QNetworkReply *reply = static_cast<QNetworkReply *>(sender());
    reply->deleteLater();

    if (reply->error()) {
        qWarning() << "Log refresh reply finished with error" << reply->errorString();
    }

    QByteArray data = reply->readAll();

    QJsonDocument jsonDoc = QJsonDocument::fromJson(data);
    qDebug() << qUtf8Printable(jsonDoc.toJson(QJsonDocument::Indented));

    QVariantList logList = jsonDoc.toVariant().toList();
    emit logsRefreshed(logList);
}

void DataManager::onResultsReady()
{
    QNetworkReply *reply = static_cast<QNetworkReply *>(sender());
    reply->deleteLater();

    if (reply->error()) {
        qWarning() << "Result refresh reply finished with error" << reply->errorString();
    }

    QByteArray data = reply->readAll();

    QJsonDocument jsonDoc = QJsonDocument::fromJson(data);
    qDebug() << qUtf8Printable(jsonDoc.toJson(QJsonDocument::Indented));

    QVariantList resultList = jsonDoc.toVariant().toList();
    emit resultsRefreshed(resultList);

}

