#ifndef LOGMESSAGE_H
#define LOGMESSAGE_H

#include <QObject>

class LogMessage : public QObject
{
    Q_OBJECT
public:
    explicit LogMessage(QObject *parent = nullptr);

signals:

public slots:
};

#endif // LOGMESSAGE_H
