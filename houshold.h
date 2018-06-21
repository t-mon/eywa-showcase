#ifndef HOUSHOLD_H
#define HOUSHOLD_H

#include <QObject>
#include <QLineSeries>

#include "dataiteration.h"

class Houshold : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name CONSTANT)

public:
    explicit Houshold(const QString &name, int number, QObject *parent = nullptr);

    QString name() const;
    int number() const;

    void reset();
    void addIteration(DataIteration *dataIteration);

    Q_INVOKABLE DataSeries *getDataSeries(int iterationNumber, QString name);

private:
    QString m_name;
    int m_number = -1;
    QList<DataIteration *> m_dataIterations;

signals:
    void dataChanged(int row, double column, double value);
    void updated();
    void reseted();

public slots:

    void setTimeSlot(int timeSlot);

};

#endif // HOUSHOLD_H
