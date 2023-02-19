#include "DropdownWithListType.h"

DropdownWithListType::DropdownWithListType(QObject *parent)
    : QObject(parent)
{
    setAllItems({});
    setSelectedItems({});
}

void DropdownWithListType::setAllItems(const QStringList &allItems)
{
    if (allItems == m_allItems)
        return;

    m_allItems = allItems;
    emit allItemsChanged();
}

void DropdownWithListType::setSelectedItems(const QStringList &selectedItems)
{
    m_selectedItems = selectedItems;

    setNotSelectedItems(setItemsInList1ThatAreNotInListImpl(m_allItems, m_selectedItems));
    emit selectedItemsChanged();
}

void DropdownWithListType::setNotSelectedItems(const QStringList &notSelectedItems)
{
    if (notSelectedItems == m_notSelectedItems)
        return;

    m_notSelectedItems = notSelectedItems;
    emit notSelectedItemsChanged();
}

void DropdownWithListType::addSelectedItem(QString item)
{
    m_selectedItems.push_back(item);
    m_notSelectedItems.removeAll(item);
    emit selectedItemsChanged();
    emit notSelectedItemsChanged();
}

void DropdownWithListType::addNotSelectedItem(QString item)
{
    m_notSelectedItems.push_back(item);
    m_selectedItems.removeAll(item);
    emit selectedItemsChanged();
    emit notSelectedItemsChanged();
}

QStringList DropdownWithListType::setItemsInList1ThatAreNotInListImpl(QStringList &list1,
                                                                      QStringList &list2)
{
    QStringList list3;
    std::remove_copy_if(list1.begin(),
                        list1.end(),
                        std::back_inserter(list3),
                        [&list2](const QString &arg) {
                            return (std::find(list2.begin(), list2.end(), arg) != list2.end());
                        });
    return list3;
}
