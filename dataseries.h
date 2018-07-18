#ifndef DATASERIES_H
#define DATASERIES_H

#include <QObject>

class DataSeries : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name NOTIFY nameChanged)
    Q_PROPERTY(double minValue READ minValue NOTIFY minValueChanged)
    Q_PROPERTY(double maxValue READ maxValue NOTIFY maxValueChanged)

public:
    explicit DataSeries(QObject *parent = nullptr);

    QString name() const;
    void setName(const QString &name);

    double minValue() const;
    void setMinValue(double minValue);

    double maxValue() const;
    void setMaxValue(double maxValue);

    QList<double> values() const;
    void setValues(const QList<double> &values);

    Q_INVOKABLE double getValue(int timeSlot);

    void setCurrentValue(int timeSlot);
    Q_INVOKABLE double getValueAt(int timeSlot);

private:
    QString m_name;
    double m_minValue = 0;
    double m_maxValue = 1;
    QList<double> m_values;

signals:
    void nameChanged();
    void minValueChanged();
    void maxValueChanged();

    void dataChanged(double x, double y);

};

#endif // DATASERIES_H
