#ifndef BLOCKS_H
#define BLOCKS_H

#include <QObject>
#include <QAbstractListModel>

#include "block.h"

class Blocks : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit Blocks(QObject *parent = nullptr);
    enum Roles {
        RoleTime,
        RoleTimeString,
        RoleMessage,
        RoleNumber,
        RoleClient,
        RoleHash
    };

    QList<Block *> blocks() const;

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

    void clearModel();
    void addBlock(Block *block);

private:
    QList<Block *> m_blocks;

signals:
    void countChanged();

protected:
    QHash<int, QByteArray> roleNames() const;

};

#endif // BLOCKS_H
