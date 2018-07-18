#ifndef BLOCK_H
#define BLOCK_H

#include <QObject>

class Block : public QObject
{
    Q_OBJECT
public:
    explicit Block(QObject *parent = nullptr);

    int timeStamp() const;
    void setTimeStamp(int timestamp);

    QString timeString() const;

    QString message() const;
    void setMessage(const QString &message);

    QString client() const;
    void setClient(const QString &client);

    int number() const;
    void setNumber(int number);

    QString hash() const;
    void setHash(const QString &hash);

private:
    int m_timeStamp;
    QString m_messageType;
    QString m_message;
    QString m_client;
    int m_number;
    QString m_hash;
};

#endif // BLOCK_H
