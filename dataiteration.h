#ifndef DATAITERATION_H
#define DATAITERATION_H

#include <QObject>

#include "dataseries.h"

class DataIteration : public QObject
{
    Q_OBJECT
public:
    explicit DataIteration(int iterationNumber, QObject *parent = nullptr);

    int iterationNumber() const;

    QList<DataSeries *> dataSeries() const;
    void setDataSeries(const QList<DataSeries *> dataSeries);

private:
    int m_iterationNumber = -1;
    QList<DataSeries *> m_dataSeries;


signals:

public slots:
};

#endif // DATAITERATION_H
