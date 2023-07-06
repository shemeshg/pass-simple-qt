#pragma once

#include <QObject>
#include <QUrl>
#include <qqmlregistration.h>
#include <QJSEngine>

#include "GpgIdManage.h"

class GpgIdManageType : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString currentPath READ currentPath CONSTANT)
    Q_PROPERTY(QString stopPath READ stopPath CONSTANT)
    Q_PROPERTY(QString nearestGpgIdFolder READ nearestGpgIdFolder CONSTANT)
    Q_PROPERTY(QString gpgPubKeysFolder READ gpgPubKeysFolder CONSTANT)
    Q_PROPERTY(QString nearestGpgIdFile READ nearestGpgIdFile CONSTANT)
    Q_PROPERTY(QStringList keysNotFoundInGpgIdFile READ keysNotFoundInGpgIdFile CONSTANT)
    Q_PROPERTY(QStringList keysFoundInGpgIdFile READ keysFoundInGpgIdFile CONSTANT)
    Q_PROPERTY(QStringList allKeys READ allKeys CONSTANT)
    Q_PROPERTY(QStringList allPrivateKeys READ allPrivateKeys CONSTANT)
    Q_PROPERTY(bool gpgPubKeysFolderExists READ gpgPubKeysFolderExists CONSTANT)
    Q_PROPERTY(bool classInitialized READ classInitialized CONSTANT)
    QML_ELEMENT

public:
    explicit GpgIdManageType(QObject *parent = nullptr)
        : QObject(parent){};

    void init(std::string _currentPath, std::string _stopPath);
    const std::vector<std::string> &getEncryptTo() const { return m_gpgIdManage->encryptTo; }
    const QString currentPath() const { return QString::fromStdString(m_gpgIdManage->currentPath); };
    const QString stopPath() const { return QString::fromStdString(m_gpgIdManage->stopPath); };
    const QString nearestGpgIdFolder()
    {
        return QString::fromStdString(m_gpgIdManage->nearestGpgIdFolder);
    };
    const QString gpgPubKeysFolder() const
    {
        return QString::fromStdString(m_gpgIdManage->gpgPubKeysFolder);
    };
    const QString nearestGpgIdFile() const
    {
        return QString::fromStdString(m_gpgIdManage->nearestGpgIdFile);
    };
    bool gpgPubKeysFolderExists() const { return m_gpgIdManage->gpgPubKeysFolderExists; };
    bool classInitialized() const { return m_gpgIdManage->classInitialized; };
    QStringList keysNotFoundInGpgIdFile() const;
    QStringList keysFoundInGpgIdFile() const;
    QStringList allPrivateKeys() const;
    QStringList allKeys() const;
    Q_INVOKABLE void importPublicKeyAndTrust(const QString &urlString);
    Q_INVOKABLE void importAllGpgPubKeysFolder();
    Q_INVOKABLE QString saveChanges(QStringList keysFound, bool doSign);
    Q_INVOKABLE void saveChangesAsync(QStringList keysFound,
                                      bool doSign,
                                    const QJSValue &callback);




signals:

private:
    std::unique_ptr<GpgIdManage> m_gpgIdManage=std::make_unique<GpgIdManage>("","");
};
