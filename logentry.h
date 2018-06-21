#ifndef LOGENTRY_H
#define LOGENTRY_H

#include <QObject>

class LogEntry: public QObject
{
    Q_OBJECT
public:
    enum MessageType {
        MessageTypeInfo,
        MessageTypeDebug
    };
    Q_ENUM(MessageType)

    LogEntry(QObject *parent = nullptr);

private:
    int m_timeStamp;
    int m_housholdNumber;
MessageType m_messageType;
QString m_message;


};

#endif // LOGENTRY_H
