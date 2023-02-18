#pragma once

#include <QObject>
#include <QQmlListProperty>
#include <qqmlregistration.h>

class DropdownWithListType : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList allItems READ allItems WRITE setAllItems NOTIFY allItemsChanged)
    Q_PROPERTY(QStringList selectedItems READ selectedItems WRITE setSelectedItems NOTIFY
                   selectedItemsChanged)
    Q_PROPERTY(QStringList notSelectedItems READ notSelectedItems WRITE setNotSelectedItems NOTIFY
                   notSelectedItemsChanged)
    // hygen Q_PROPERTY
    QML_ELEMENT

public:
    explicit DropdownWithListType(QObject *parent = nullptr)
        : QObject(parent)
    {
        setAllItems({});
        setSelectedItems({});
    };
    QStringList allItems() { return m_allItems; };

    void setAllItems(const QStringList &allItems)
    {
        if (allItems == m_allItems)
            return;

        m_allItems = allItems;
        emit allItemsChanged();
    }
    QStringList selectedItems() { return m_selectedItems; };

    void setSelectedItems(const QStringList &selectedItems)
    {
        m_selectedItems = selectedItems;
        emit selectedItemsChanged();

        setNotSelectedItems(setItemsInList1ThatAreNotInList2(m_allItems, m_selectedItems));
    }
    QStringList notSelectedItems() { return m_notSelectedItems; };

    void setNotSelectedItems(const QStringList &notSelectedItems)
    {
        if (notSelectedItems == m_notSelectedItems)
            return;

        m_notSelectedItems = notSelectedItems;
        emit notSelectedItemsChanged();
    }
    // hygen public
    Q_INVOKABLE void addSelectedItem(QString item)
    {
        m_selectedItems.push_back(item);
        m_notSelectedItems.removeAll(item);
        emit selectedItemsChanged();
        emit notSelectedItemsChanged();
    }

    Q_INVOKABLE void addNotSelectedItem(QString item)
    {
        m_notSelectedItems.push_back(item);
        m_selectedItems.removeAll(item);
        emit selectedItemsChanged();
        emit notSelectedItemsChanged();
    }

signals:
    void allItemsChanged();
    void selectedItemsChanged();
    void notSelectedItemsChanged();
    // hygen signals

private:
    QStringList m_allItems;
    QStringList m_selectedItems;
    QStringList m_notSelectedItems;
    // hygen private

    QStringList setItemsInList1ThatAreNotInList2(QStringList &list1, QStringList &list2)
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
};
