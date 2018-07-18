#ifndef DATAMANAGER_H
#define DATAMANAGER_H

#include <QObject>
#include <QNetworkAccessManager>

class DataManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString hostAddress READ hostAddress WRITE setHostAddress NOTIFY hostAddressChanged)
    Q_PROPERTY(int port READ port WRITE setPort NOTIFY portChanged)

public:
    explicit DataManager(QObject *parent = nullptr);

    QString hostAddress() const;
    void setHostAddress(const QString &hostAddress);

    int port() const;
    void setPort(int port);


    Q_INVOKABLE void refresh();

private:
    QNetworkAccessManager *m_networkManager = nullptr;

    QString m_hostAddress = "192.168.0.183";
    int m_port = 8080;

    QVariant loadJsonFile(const QString &fileName);

signals:
    void hostAddressChanged();
    void portChanged();

    void logsRefreshed(const QVariantList &logsList);
    void resultsRefreshed(const QVariantList &resultsList);

private slots:
    void onLogsReady();
    void onResultsReady();

};

#endif // DATAMANAGER_H
