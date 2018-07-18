#include "logentry.h"

#include <QDateTime>

LogEntry::LogEntry()
{

}

int LogEntry::timeStamp() const
{
    return m_timeStamp;
}

void LogEntry::setTimeStamp(int timestamp)
{
    m_timeStamp = timestamp;
}

QString LogEntry::timeString() const
{
    return QDateTime::fromTime_t(m_timeStamp).toString("dd.MM.yyyy hh:mm:ss");
}

QString LogEntry::message() const
{
    return m_message;
}

void LogEntry::setMessage(const QString &message)
{
    m_message = message;
}

QString LogEntry::messageType() const
{
    return m_messageType;
}

void LogEntry::setMessageType(const QString &messageType)
{
    m_messageType = messageType;
}
