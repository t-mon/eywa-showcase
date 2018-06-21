#include "dataiteration.h"

DataIteration::DataIteration(int iterationNumber, QObject *parent) :
    QObject(parent),
    m_iterationNumber(iterationNumber)
{

}

int DataIteration::iterationNumber() const
{
    return m_iterationNumber;
}

QList<DataSeries *> DataIteration::dataSeries() const
{
    return m_dataSeries;
}

void DataIteration::setDataSeries(const QList<DataSeries *> dataSeries)
{
    m_dataSeries = dataSeries;
}
