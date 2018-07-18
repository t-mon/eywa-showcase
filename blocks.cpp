#include "blocks.h"

Blocks::Blocks(QObject *parent) :
    QAbstractListModel(parent)
{

}

QList<Block *> Blocks::blocks() const
{
    return m_blocks;
}

int Blocks::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_blocks.count();
}

QVariant Blocks::data(const QModelIndex &index, int role) const
{
    Block *block = m_blocks.at(index.row());
    switch (role) {
    case RoleTime:
        return block->timeStamp();
    case RoleTimeString:
        return block->timeString();
    case RoleMessage:
        return block->message();
    case RoleNumber:
        return block->number();
    case RoleHash:
        return block->hash();
    case RoleClient:
        return block->client();
    }

    return QVariant();
}

void Blocks::clearModel()
{
    beginResetModel();
    qDeleteAll(m_blocks);
    m_blocks.clear();
    endResetModel();

    emit countChanged();
}

void Blocks::addBlock(Block *block)
{
    beginInsertRows(QModelIndex(), m_blocks.count(), m_blocks.count());
    m_blocks.append(block);
    endInsertRows();

    emit countChanged();
}

QHash<int, QByteArray> Blocks::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles.insert(RoleTime, "time");
    roles.insert(RoleTimeString, "timeString");
    roles.insert(RoleMessage, "message");
    roles.insert(RoleNumber, "number");
    roles.insert(RoleHash, "hash");
    roles.insert(RoleClient, "client");
    return roles;
}
