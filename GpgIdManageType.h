#pragma once

#include <QObject>
#include <qqmlregistration.h>

#include "GpgIdManage.h"
#include "QtCore/qdebug.h"
#include <QUrl>

class GpgIdManageType : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString currentPath READ currentPath CONSTANT )
    Q_PROPERTY(QString stopPath READ stopPath CONSTANT )
    Q_PROPERTY(QString nearestGpgIdFolder READ nearestGpgIdFolder CONSTANT )
    Q_PROPERTY(QString gpgPubKeysFolder READ gpgPubKeysFolder CONSTANT )
    Q_PROPERTY(QString nearestGpgIdFile READ nearestGpgIdFile CONSTANT )
    Q_PROPERTY(QStringList  keysNotFoundInGpgIdFile READ keysNotFoundInGpgIdFile CONSTANT)
    Q_PROPERTY(QStringList  keysFoundInGpgIdFile READ keysFoundInGpgIdFile CONSTANT)
    Q_PROPERTY(QStringList  allKeys READ allKeys CONSTANT)
    Q_PROPERTY(bool  gpgPubKeysFolderExists READ gpgPubKeysFolderExists CONSTANT)
    Q_PROPERTY(bool  classInitialized READ classInitialized CONSTANT)


    // hygen Q_PROPERTY
    QML_ELEMENT

public:
    explicit GpgIdManageType(QObject *parent = nullptr) : QObject(parent){};

    void init(std::string _currentPath, std::string _stopPath, PassHelper *_ph){
        m_gpgIdManage.init(_currentPath, _stopPath, _ph);

    }

    std::vector<std::string> &getEncryptTo(){
        return m_gpgIdManage.encryptTo;
    }

    QString currentPath()
    {
        return QString::fromStdString(m_gpgIdManage.currentPath);
    };


    QString stopPath()
    {
        return QString::fromStdString(m_gpgIdManage.stopPath);
    };


    QString nearestGpgIdFolder()
    {
        return QString::fromStdString(m_gpgIdManage.nearestGpgIdFolder);
    };


    QString gpgPubKeysFolder()
    {
        return QString::fromStdString(m_gpgIdManage.gpgPubKeysFolder);
    };

    QString nearestGpgIdFile()
    {
        return QString::fromStdString(m_gpgIdManage.nearestGpgIdFile);
    };

    bool gpgPubKeysFolderExists()
    {
        return m_gpgIdManage.gpgPubKeysFolderExists;
    };

    bool classInitialized()
    {
        return m_gpgIdManage.classInitialized;
    };



    QStringList  keysNotFoundInGpgIdFile()
    {
        QStringList l;
        for (auto r : m_gpgIdManage.KeysNotFoundInGpgIdFile){
            l.append(QString::fromStdString(r));
        }
        return l;
    };


    QStringList  keysFoundInGpgIdFile()
    {
        QStringList l;
        for (auto r : m_gpgIdManage.keysFoundInGpgIdFile){
            l.append(QString::fromStdString(r.getKeyStr()));
        }
        return l;
    };

    QStringList  allKeys()
    {
        QStringList l;
        for (auto r : m_gpgIdManage.allKeys){
            l.append(QString::fromStdString(r.getKeyStr()));
        }
        return l;
    };

    Q_INVOKABLE void importPublicKeyAndTrust(const QString &urlString){
        const QUrl url(urlString);
        const QString localpath = url.toLocalFile();
        try {
            m_gpgIdManage.importPublicKeyAndTrust(localpath.toStdString());
        } catch (const std::exception& e) {
            qDebug()<<QString(e.what());
        }
    }

    Q_INVOKABLE void importAllGpgPubKeysFolder(){
        try {
            m_gpgIdManage.importAllGpgPubKeysFolder();
        } catch (const std::exception& e) {
            qDebug()<<QString(e.what());
        }
        qDebug()<<"Finished importAllGpgPubKeysFolder\n";
    }

    Q_INVOKABLE void saveChanges(QStringList keysFound){
        try {
            m_gpgIdManage.keysFoundInGpgIdFile.clear();

            for (const QString &line : keysFound) {
                m_gpgIdManage.populateKeyFromString(line.toStdString());
            }

            m_gpgIdManage.saveBackGpgIdFile();
            m_gpgIdManage.exportGpgIdToGpgPubKeysFolder();
            m_gpgIdManage.reEncryptStoreFolder( [&](std::string s){
                qDebug()<<"Re-Encrypt "<<QString::fromStdString(s)<<"\n";
            });

        } catch (const std::exception& e) {
            qDebug()<<QString(e.what());
        }
        qDebug()<<"Finished saveChanges\n";


    }


signals:

    // hygen signals

private:
    // hygen private
    GpgIdManage m_gpgIdManage;
};

