#include "mainqmltype.h"





MainQmlType::MainQmlType(QObject *parent) :
    QObject(parent)
{
}

QString MainQmlType::userName()
{
    return m_userName;
}

void MainQmlType::setUserName(const QString &userName)
{
    if (userName == m_userName)
        return;

    m_userName = userName;
    emit userNameChanged();
}

