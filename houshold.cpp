#include "houshold.h"

#include <QFile>
#include <QDebug>

Houshold::Houshold(const QString &name, int number, QObject *parent) :
    QObject(parent),
    m_name(name),
    m_number(number)
{
//    QStringList dataSeriesNames;
//    dataSeriesNames << "Anwesenheit E-Auto [0/1]";
//    dataSeriesNames << "Anwesenheit Temperatur [0/1]";
//    dataSeriesNames << "Außentemperatur [°C]";
//    dataSeriesNames << "Einspeisetarif [€/kWh]";
//    dataSeriesNames << "Energiekosten [€/kWh]";
//    dataSeriesNames << "Energiepreis [€/kWh]";
//    dataSeriesNames << "";
//    dataSeriesNames << "";
//    dataSeriesNames << "";
//    dataSeriesNames << "";
//    dataSeriesNames << "";
//    dataSeriesNames << "";
//    dataSeriesNames << "";
//    dataSeriesNames << "";
//    dataSeriesNames << "";
//    dataSeriesNames << "";
//    dataSeriesNames << "";
//    dataSeriesNames << "";
//    dataSeriesNames << "";
//    dataSeriesNames << "";
//    dataSeriesNames << "";
//    dataSeriesNames << "";
//    dataSeriesNames << "";
//    dataSeriesNames << "";
//    dataSeriesNames << "";
//    dataSeriesNames << "";

}

QString Houshold::name() const
{
    return m_name;
}

int Houshold::number() const
{
    return m_number;
}

void Houshold::reset()
{
    qDeleteAll(m_dataIterations);
    m_dataIterations.clear();
    emit reseted();
}

void Houshold::addIteration(DataIteration *dataIteration)
{
    m_dataIterations.append(dataIteration);
    emit updated();
}

DataSeries *Houshold::getDataSeries(int iterationNumber, QString name)
{
    foreach (DataIteration *iteration, m_dataIterations) {

        if (iteration->iterationNumber() != iterationNumber)
            continue;

        foreach (DataSeries *dataSeries, iteration->dataSeries()) {
            if (dataSeries->name() == name) {
                qDebug() << "Get time series" << dataSeries->name();
                return dataSeries;
            }
        }
    }

    qDebug() << "Could not find time series" << name << "for iteration" << iterationNumber;
    return nullptr;
}

//void Houshold::loadFile(const QString &fileName)
//{
//    QFile file(fileName);
//    if (!file.open(QFile::ReadOnly)) {
//        qWarning() << "Could not open file" << fileName << file.errorString();
//        return;
//    }

//    qDebug() << "Load" << fileName;

//    QByteArray data = file.readAll();
//    QList<QByteArray> rows = data.split('\n');
//    QString firstLine = QString::fromUtf8(rows.at(0));
//    QStringList names = firstLine.split(',');

//    // Check if first line
//    for (int i = 0; i < names.count(); i++) {
//        DataSeries *series = new DataSeries(this);
//        qDebug() << "-->" << names.at(i);
//        series->setName(names.at(i));
//        m_dataSeries.append(series);
//    }

//    for (int row = 1; row < rows.count(); row++) {
//        QString line = QString::fromUtf8(rows.at(row));

//        if (line.trimmed().isEmpty())
//            continue;

//        QStringList columns = line.split(',');
//        Q_ASSERT(m_dataSeries.count() == columns.count());

//        for (int column = 0; column < columns.count(); column++) {
//            bool ok = false;
//            double value = QString(columns.at(column)).toDouble(&ok);
//            if (!ok) {
//                qWarning() << "No data in" << row << column << "Default to 0";
//                value = 0;
//            }

//            QList<double> values = m_dataSeries.at(column)->values();
//            values.append(value);
//            m_dataSeries.at(column)->setValues(values);
//        }
//    }

//    foreach (DataSeries *series, m_dataSeries) {
//        qDebug() << fileName << "Data Series:" << series->name();
//        qDebug() << fileName << "           :" << series->values();
//    }

//}

void Houshold::setTimeSlot(int timeSlot)
{
    foreach (DataIteration *iteration, m_dataIterations) {
        for (int column = 0; column < iteration->dataSeries().count(); column++) {

            Q_ASSERT(column < iteration->dataSeries().count());

            DataSeries *series = iteration->dataSeries().at(column);
            series->setCurrentValue(timeSlot);
        }
    }

}
