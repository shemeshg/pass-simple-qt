#pragma once

#include <QObject>
#include <QUrl>
#include <qqmlregistration.h>
#include <QJSEngine>

#include "GpgIdManage.h"
#include "JsAsync.h"

class GpgIdManageType : public JsAsync
{
    Q_OBJECT
    /* [[[cog
    import cog
    import gpgIdManageType
    cog.outl(gpgIdManageType.getQ_Properties(),
        dedent=True, trimblanklines=True)
    ]]] */
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

    //[[[end]]]
    QML_ELEMENT

public:
    explicit GpgIdManageType(QObject *parent = nullptr)
        : JsAsync(parent){};

    void init(std::string _currentPath, std::string _stopPath);
    const std::vector<std::string> &getEncryptTo() const { return m_gpgIdManage->encryptTo; }

    /* [[[cog
    import cog
    import gpgIdManageType
    cog.outl(gpgIdManageType.getQ_header_publics(),
        dedent=True, trimblanklines=True)
    ]]] */
    const QString currentPath() const { return QString::fromStdString(m_gpgIdManage->currentPath); };
    const QString stopPath() const { return QString::fromStdString(m_gpgIdManage->stopPath); };
    const QString nearestGpgIdFolder() const { return QString::fromStdString(m_gpgIdManage->nearestGpgIdFolder); };
    const QString gpgPubKeysFolder() const { return QString::fromStdString(m_gpgIdManage->gpgPubKeysFolder); };
    const QString nearestGpgIdFile() const { return QString::fromStdString(m_gpgIdManage->nearestGpgIdFile); };
    QStringList keysNotFoundInGpgIdFile() const;
    QStringList keysFoundInGpgIdFile() const;
    QStringList allKeys() const;
    QStringList allPrivateKeys() const;
    bool gpgPubKeysFolderExists() const { return m_gpgIdManage->gpgPubKeysFolderExists; };
    bool classInitialized() const { return m_gpgIdManage->classInitialized; };

    //[[[end]]]

    Q_INVOKABLE QString importPublicKeyAndTrust(const QString &urlString);
    Q_INVOKABLE QString importAllGpgPubKeysFolder();
    Q_INVOKABLE QString saveChanges(QStringList keysFound, bool doSign, QString signerStr);
    Q_INVOKABLE void saveChangesAsync(QStringList keysFound,
                                      bool doSign,
                                      QString signerStr,
                                    const QJSValue &callback);




signals:

private:
    std::unique_ptr<GpgIdManage> m_gpgIdManage=std::make_unique<GpgIdManage>("","");

};
