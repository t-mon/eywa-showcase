#ifndef LOGENTRIES_H
#define LOGENTRIES_H

#include <QObject>
#include <QAbstractListModel>

#include "logentry.h"

class LogEntries : public QAbstractListModel
{
    Q_OBJECT
public:
    enum Roles {
        RoleTime,
        RoleTimeString,
        RoleMessage,
        RoleType
    };

    explicit LogEntries(QObject *parent = nullptr);

    QList<LogEntry *> logEntries() const;

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

    void clearModel();
    void addLogEntry(LogEntry *logEntry);

private:
    QList<LogEntry *> m_logEntries;

signals:
    void countChanged();

protected:
    QHash<int, QByteArray> roleNames() const;

};

#endif // LOGENTRIES_H
