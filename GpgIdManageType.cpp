#include "GpgIdManageType.h"
#include <QDebug>
#include <QtConcurrent>

void GpgIdManageType::init(std::string _currentPath,
                           std::string _stopPath,
                           bool _isRnPgp,
                           std::string _rnpHomePath,
                        std::function<bool(RnpLoginRequestException &e)> rnpPasswdPrompt)
{
    m_gpgIdManage = std::make_unique<GpgIdManage>(_currentPath, _stopPath, _isRnPgp, _rnpHomePath, rnpPasswdPrompt);
}

/* [[[cog
    import cog
    import gpgIdManageType
    cog.outl(gpgIdManageType.getQ_src_publics(),
        dedent=True, trimblanklines=True)
    ]]] */
QStringList GpgIdManageType::keysNotFoundInGpgIdFile() const
{
    QStringList l;
    for (auto r : m_gpgIdManage->keysNotFoundInGpgIdFile) {
        l.append(QString::fromStdString(r));
    }
    return l;
}
QStringList GpgIdManageType::keysFoundInGpgIdFile() const
{
    QStringList l;
    for (auto r : m_gpgIdManage->keysFoundInGpgIdFile) {
        l.append(QString::fromStdString(r.getKeyStr()));
    }
    return l;
}
QStringList GpgIdManageType::allKeys() const
{
    QStringList l;
    for (auto r : m_gpgIdManage->allKeys) {
        l.append(QString::fromStdString(r.getKeyStr()));
    }
    return l;
}
QStringList GpgIdManageType::allPrivateKeys() const
{
    QStringList l;
    for (auto r : m_gpgIdManage->allPrivateKeys) {
        l.append(QString::fromStdString(r.getKeyStr()));
    }
    return l;
}

//[[[end]]]
QString GpgIdManageType::importPublicKeyAndTrust(const QString &urlString)
{
    const QUrl url(urlString);
    const QString localpath = url.toLocalFile();
    try {
        m_gpgIdManage->importPublicKeyAndTrust(localpath.toStdString());
        return "";
    } catch (const std::exception &e) {
        return QString(e.what());
    }
}

QString GpgIdManageType::importAllGpgPubKeysFolder()
{
    try {
        m_gpgIdManage->importAllGpgPubKeysFolder();
    } catch (const std::exception &e) {
        return QString(e.what());
    }
    return "";
}

QString GpgIdManageType::saveChanges(QStringList keysFound, bool doSign, QString signerStr)
{
    QString currentFile = "";
    try {
        m_gpgIdManage->keysFoundInGpgIdFile.clear();

        for (const QString &line : keysFound) {
            m_gpgIdManage->populateKeyFromString(line.toStdString());
        }

        m_gpgIdManage->saveBackGpgIdFile();
        m_gpgIdManage->exportGpgIdToGpgPubKeysFolder();
        m_gpgIdManage = std::make_unique<GpgIdManage>(m_gpgIdManage->currentPath,
                                                      m_gpgIdManage->stopPath,
                                                      m_gpgIdManage->isRnPgp,
                                                      m_gpgIdManage->rnpHomePath,
                                                      m_gpgIdManage->rnpPasswdPrompt
                                                      );
        try {
            m_gpgIdManage->setSigner(signerStr.toStdString());
        } catch (...) {
            qDebug() << "Bad signer Id \n"; // Block of code to handle errors
        }
        m_gpgIdManage->reEncryptStoreFolder(
            [&](std::string s) {
                currentFile = QString::fromStdString(s);
                qDebug() << "Re-Encrypt " << currentFile << "\n";
            },
            doSign);

    } catch (RnpLoginRequestException &rlre) {
        rlre.functionName = "reEncrypt";
        emit loginRequestedRnpG(rlre);
    } catch (const std::exception &e) {
        qDebug() <<"Error "<< QString(e.what());
        return "Error:\n" + currentFile + "\n" + e.what() + "\n";
    }
    qDebug() << "Finished saveChanges\n";
    return "";
}

void GpgIdManageType::saveChangesAsync(QStringList keysFound, bool doSign, QString signerStr, const QJSValue &callback)
{
    makeAsync<QString>(callback,[=]() {
        return saveChanges(keysFound, doSign, signerStr);
    });

}
