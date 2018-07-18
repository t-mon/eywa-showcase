#include "blocksproxy.h"

BlocksProxy::BlocksProxy(QObject *parent) :
    QSortFilterProxyModel(parent)
{
    setSortRole(Blocks::RoleNumber);
}

Blocks *BlocksProxy::blocks()
{
    return m_blocks;
}

void BlocksProxy::setBlocks(Blocks *blocks)
{
    m_blocks = blocks;
    setSourceModel(m_blocks);
    sort(0);
}
