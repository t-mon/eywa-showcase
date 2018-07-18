#ifndef BLOCKSPROXY_H
#define BLOCKSPROXY_H

#include <QObject>
#include <QSortFilterProxyModel>

#include "blocks.h"

class BlocksProxy : public QSortFilterProxyModel
{
    Q_OBJECT
public:
    explicit BlocksProxy(QObject *parent = nullptr);

    Blocks *blocks();
    void setBlocks(Blocks *blocks);

private:
    Blocks *m_blocks = nullptr;

};

#endif // BLOCKSPROXY_H
