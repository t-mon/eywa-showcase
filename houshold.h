#ifndef HOUSHOLD_H
#define HOUSHOLD_H

#include <QObject>
#include <QLineSeries>

#include "dataseries.h"

class Houshold : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name CONSTANT)

public:
    explicit Houshold(const QString &name, QObject *parent = nullptr);

    QString name() const;

    Q_INVOKABLE DataSeries *getDataSeries(int column);

private:
    QString m_name;
    QList<DataSeries *> m_dataSeries;

signals:
    void dataChanged(int row, double column, double value);

public slots:
    void loadFile(const QString &fileName);

    void setTimeSlot(int timeSlot);

};

#endif // HOUSHOLD_H
