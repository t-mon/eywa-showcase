#include "dataseries.h"

#include <QDebug>

DataSeries::DataSeries(QObject *parent) : QObject(parent)
{

}

QString DataSeries::name() const
{
    return m_name;
}

void DataSeries::setName(const QString &name)
{
    m_name = name;
    emit nameChanged();
}

double DataSeries::minValue() const
{
    return m_minValue;
}

void DataSeries::setMinValue(double minValue)
{
    m_minValue = minValue;
    emit minValueChanged();
}

double DataSeries::maxValue() const
{
    return m_maxValue;
}

void DataSeries::setMaxValue(double maxValue)
{
    m_maxValue = maxValue;
    emit maxValueChanged();
}

QList<double> DataSeries::values() const
{
    return m_values;
}

void DataSeries::setValues(const QList<double> &values)
{
    m_values = values;
}

void DataSeries::setCurrentValue(int timeSlot)
{
    Q_ASSERT(timeSlot < m_values.count());

    double y = m_values.at(timeSlot);

    qDebug() << "Value for" << name() << "changed" << y;

    if (y < m_minValue)
        setMinValue(y);

    if (y > m_maxValue)
        setMaxValue(y);

    emit dataChanged(timeSlot, y);
}

double DataSeries::getValueAt(int timeSlot)
{
    Q_ASSERT(timeSlot < m_values.count());

    double y = m_values.at(timeSlot);

    if (y < m_minValue)
        setMinValue(y);

    if (y > m_maxValue)
        setMaxValue(y);

    return y;
}
