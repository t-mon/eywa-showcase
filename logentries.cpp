#include "logentries.h"

LogEntries::LogEntries(QObject *parent) :
    QAbstractListModel(parent)
{

}

QList<LogEntry *> LogEntries::logEntries() const
{
    return m_logEntries;
}

int LogEntries::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_logEntries.count();
}

QVariant LogEntries::data(const QModelIndex &index, int role) const
{
    LogEntry *logEntry = m_logEntries.at(index.row());
    switch (role) {
    case RoleTime:
        return logEntry->timeStamp();
    case RoleTimeString:
        return logEntry->timeString();
    case RoleMessage:
        return logEntry->message();
    case RoleType:
        return logEntry->messageType();
    }

    return QVariant();
}

void LogEntries::clearModel()
{
    beginResetModel();
    qDeleteAll(m_logEntries);
    m_logEntries.clear();
    endResetModel();

    emit countChanged();
}

void LogEntries::addLogEntry(LogEntry *logEntry)
{
    beginInsertRows(QModelIndex(), m_logEntries.count(), m_logEntries.count());
    m_logEntries.append(logEntry);
    endInsertRows();

    emit countChanged();
}

QHash<int, QByteArray> LogEntries::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles.insert(RoleTime, "time");
    roles.insert(RoleTimeString, "timeString");
    roles.insert(RoleMessage, "message");
    roles.insert(RoleType, "messageType");
    return roles;
}
