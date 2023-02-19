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
    explicit DropdownWithListType(QObject *parent = nullptr);
    ;
    const QStringList &allItems() const { return m_allItems; };

    void setAllItems(const QStringList &allItems);
    QStringList selectedItems() { return m_selectedItems; };

    void setSelectedItems(const QStringList &selectedItems);
    const QStringList &notSelectedItems() const { return m_notSelectedItems; };

    void setNotSelectedItems(const QStringList &notSelectedItems);
    // hygen public
    Q_INVOKABLE void addSelectedItem(QString item);
    Q_INVOKABLE void addNotSelectedItem(QString item);

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
    QStringList setItemsInList1ThatAreNotInListImpl(QStringList &list1, QStringList &list2);
};
