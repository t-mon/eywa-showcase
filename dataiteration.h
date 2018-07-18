#ifndef DATAITERATION_H
#define DATAITERATION_H

#include <QObject>

#include "logentries.h"
#include "logentriesproxy.h"

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

};

#endif // DATAITERATION_H
