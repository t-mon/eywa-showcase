#ifndef LOGENTRIESPROXY_H
#define LOGENTRIESPROXY_H

#include <QObject>
#include <QSortFilterProxyModel>

#include "logentries.h"

class LogEntriesProxy : public QSortFilterProxyModel
{
    Q_OBJECT
public:
    explicit LogEntriesProxy(QObject *parent = nullptr);

    LogEntries *logEntries();
    void setLogEntries(LogEntries *logEntries);

private:
    LogEntries *m_logEntries = nullptr;

};

#endif // LOGENTRIESPROXY_H
