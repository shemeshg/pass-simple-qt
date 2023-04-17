#include "GpgIdManageType.h"
#include <QDebug>

void GpgIdManageType::init(std::string _currentPath, std::string _stopPath, PassHelper *_ph)
{
    m_gpgIdManage.init(_currentPath, _stopPath, _ph);
}

QStringList GpgIdManageType::keysNotFoundInGpgIdFile() const
{
    QStringList l;
    for (auto r : m_gpgIdManage.KeysNotFoundInGpgIdFile) {
        l.append(QString::fromStdString(r));
    }
    return l;
}

QStringList GpgIdManageType::keysFoundInGpgIdFile() const
{
    QStringList l;
    for (auto r : m_gpgIdManage.keysFoundInGpgIdFile) {
        l.append(QString::fromStdString(r.getKeyStr()));
    }
    return l;
}

QStringList GpgIdManageType::allPrivateKeys() const
{
    QStringList l;
    for (auto r : m_gpgIdManage.allPrivateKeys) {
        l.append(QString::fromStdString(r.getKeyStr()));
    }
    return l;
}

QStringList GpgIdManageType::allKeys() const
{
    QStringList l;
    for (auto r : m_gpgIdManage.allKeys) {
        l.append(QString::fromStdString(r.getKeyStr()));
    }
    return l;
}

void GpgIdManageType::importPublicKeyAndTrust(const QString &urlString)
{
    const QUrl url(urlString);
    const QString localpath = url.toLocalFile();
    try {
        m_gpgIdManage.importPublicKeyAndTrust(localpath.toStdString());
    } catch (const std::exception &e) {
        qDebug() << QString(e.what());
    }
}

void GpgIdManageType::importAllGpgPubKeysFolder()
{
    try {
        m_gpgIdManage.importAllGpgPubKeysFolder();
    } catch (const std::exception &e) {
        qDebug() << QString(e.what());
    }
    qDebug() << "Finished importAllGpgPubKeysFolder\n";
}

QString GpgIdManageType::saveChanges(QStringList keysFound)
{
    QString currentFile = "";
    try {
        m_gpgIdManage.keysFoundInGpgIdFile.clear();

        for (const QString &line : keysFound) {
            m_gpgIdManage.populateKeyFromString(line.toStdString());
        }

        m_gpgIdManage.saveBackGpgIdFile();
        m_gpgIdManage.exportGpgIdToGpgPubKeysFolder();
        m_gpgIdManage.reInit();
        m_gpgIdManage.reEncryptStoreFolder(
            [&](std::string s) {
                currentFile = QString::fromStdString(s);
                qDebug() << "Re-Encrypt " << currentFile << "\n";
            });

    } catch (const std::exception &e) {
        qDebug() <<"Error "<< QString(e.what());
        return "Error:\n" + currentFile + "\n" + e.what() + "\n";

    }
    qDebug() << "Finished saveChanges\n";
    return "";
}
