#ifndef LOGENTRY_H
#define LOGENTRY_H

#include <QString>

class LogEntry
{
public:
    LogEntry();

    int timeStamp() const;
    void setTimeStamp(int timestamp);

    QString timeString() const;

    QString message() const;
    void setMessage(const QString &message);

    QString messageType() const;
    void setMessageType(const QString &messageType);

private:
    int m_timeStamp;
    QString m_messageType;
    QString m_message;

};

#endif // LOGENTRY_H
