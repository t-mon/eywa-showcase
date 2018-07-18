#include "logentry.h"

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
