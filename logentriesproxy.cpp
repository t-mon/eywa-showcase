#include "logentriesproxy.h"

LogEntriesProxy::LogEntriesProxy(QObject *parent) : QSortFilterProxyModel(parent)
{
    setSortRole(LogEntries::RoleTime);
}

LogEntries *LogEntriesProxy::logEntries()
{
    return m_logEntries;
}

void LogEntriesProxy::setLogEntries(LogEntries *logEntries)
{
    m_logEntries = logEntries;
    setSourceModel(m_logEntries);
    sort(0);
}
