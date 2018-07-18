#include "block.h"

#include <QDateTime>

Block::Block(QObject *parent) : QObject(parent)
{

}

int Block::timeStamp() const
{
    return m_timeStamp;
}

void Block::setTimeStamp(int timestamp)
{
    m_timeStamp = timestamp;
}

QString Block::timeString() const
{
    return QDateTime::fromTime_t(m_timeStamp).toString("dd.MM.yyyy hh:mm:ss");
}

QString Block::message() const
{
    return m_message;
}

void Block::setMessage(const QString &message)
{
    m_message = message;
}

QString Block::client() const
{
    return m_client;
}

void Block::setClient(const QString &client)
{
    m_client = client;
}

int Block::number() const
{
    return m_number;
}

void Block::setNumber(int number)
{
    m_number = number;
}

QString Block::hash() const
{
    return m_hash;
}

void Block::setHash(const QString &hash)
{
    m_hash = hash;
}
