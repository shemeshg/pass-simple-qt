#ifndef MAINQMLTYPE_H
#define MAINQMLTYPE_H
#include <qqmlregistration.h>

#include <QObject>

class MainQmlType : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString userName READ userName WRITE setUserName NOTIFY userNameChanged)
    QML_ELEMENT

public:
    explicit MainQmlType(QObject *parent = nullptr);

    QString userName();
    void setUserName(const QString &userName);

signals:
    void userNameChanged();

private:
    QString m_userName;
};

#endif // MAINQMLTYPE_H
