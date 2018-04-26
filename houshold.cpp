#include "houshold.h"

#include <QFile>
#include <QDebug>

Houshold::Houshold(const QString &name, QObject *parent) :
    QObject(parent),
    m_name(name)
{


}

QString Houshold::name() const
{
    return m_name;
}

DataSeries *Houshold::getDataSeries(int column)
{
    if (m_dataSeries.count() <= column) {
        qWarning() << "!! No column" << column;
        return nullptr;
    }

    qDebug() << "Get time series" << column << m_dataSeries.at(column)->name();
    return m_dataSeries.at(column);
}

void Houshold::loadFile(const QString &fileName)
{
    QFile file(fileName);
    if (!file.open(QFile::ReadOnly)) {
        qWarning() << "Could not open file" << fileName << file.errorString();
        return;
    }

    qDebug() << "Load" << fileName;

    QByteArray data = file.readAll();
    QList<QByteArray> rows = data.split('\n');
    QString firstLine = QString::fromUtf8(rows.at(0));
    QStringList names = firstLine.split(',');

    // Check if first line
    for (int i = 0; i < names.count(); i++) {
        DataSeries *series = new DataSeries(this);
        qDebug() << "-->" << names.at(i);
        series->setName(names.at(i));
        m_dataSeries.append(series);
    }

    for (int row = 1; row < rows.count(); row++) {
        QString line = QString::fromUtf8(rows.at(row));

        if (line.trimmed().isEmpty())
            continue;

        QStringList columns = line.split(',');
        Q_ASSERT(m_dataSeries.count() == columns.count());

        for (int column = 0; column < columns.count(); column++) {
            bool ok = false;
            double value = QString(columns.at(column)).toDouble(&ok);
            if (!ok) {
                qWarning() << "No data in" << row << column << "Default to 0";
                value = 0;
            }

            QList<double> values = m_dataSeries.at(column)->values();
            values.append(value);
            m_dataSeries.at(column)->setValues(values);
        }
    }

    foreach (DataSeries *series, m_dataSeries) {
        qDebug() << fileName << "Data Series:" << series->name();
        qDebug() << fileName << "           :" << series->values();
    }

}

void Houshold::setTimeSlot(int timeSlot)
{
    for (int column = 0; column < m_dataSeries.count(); column++) {

        Q_ASSERT(column < m_dataSeries.count());

        DataSeries *series = m_dataSeries.at(column);
        series->setCurrentValue(timeSlot);
    }
}
