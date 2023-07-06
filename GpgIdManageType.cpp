#include "GpgIdManageType.h"
#include <QDebug>
#include <QtConcurrent>

void GpgIdManageType::init(std::string _currentPath, std::string _stopPath)
{
    m_gpgIdManage=std::make_unique<GpgIdManage>(_currentPath,_stopPath);
}

QStringList GpgIdManageType::keysNotFoundInGpgIdFile() const
{
    QStringList l;
    for (const auto &r : m_gpgIdManage->KeysNotFoundInGpgIdFile) {
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

QStringList GpgIdManageType::allPrivateKeys() const
{
    QStringList l;
    for (auto r : m_gpgIdManage->allPrivateKeys) {
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

void GpgIdManageType::importPublicKeyAndTrust(const QString &urlString)
{
    const QUrl url(urlString);
    const QString localpath = url.toLocalFile();
    try {
        m_gpgIdManage->importPublicKeyAndTrust(localpath.toStdString());
    } catch (const std::exception &e) {
        qDebug() << QString(e.what());
    }
}

void GpgIdManageType::importAllGpgPubKeysFolder()
{
    try {
        m_gpgIdManage->importAllGpgPubKeysFolder();
    } catch (const std::exception &e) {
        qDebug() << QString(e.what());
    }
    qDebug() << "Finished importAllGpgPubKeysFolder\n";
}

QString GpgIdManageType::saveChanges(QStringList keysFound, bool doSign)
{
    QString currentFile = "";
    try {
        m_gpgIdManage->keysFoundInGpgIdFile.clear();

        for (const QString &line : keysFound) {
            m_gpgIdManage->populateKeyFromString(line.toStdString());
        }

        m_gpgIdManage->saveBackGpgIdFile();
        m_gpgIdManage->exportGpgIdToGpgPubKeysFolder();
        m_gpgIdManage=std::make_unique<GpgIdManage>(m_gpgIdManage->currentPath,m_gpgIdManage->stopPath);
        m_gpgIdManage->reEncryptStoreFolder(
            [&](std::string s) {
                currentFile = QString::fromStdString(s);
                qDebug() << "Re-Encrypt " << currentFile << "\n";
            },
            doSign);

    } catch (const std::exception &e) {
        qDebug() <<"Error "<< QString(e.what());
        return "Error:\n" + currentFile + "\n" + e.what() + "\n";

    }
    qDebug() << "Finished saveChanges\n";
    return "";
}

void GpgIdManageType::saveChangesAsync(QStringList keysFound, bool doSign, const QJSValue &callback)
{
    auto *watcher = new QFutureWatcher<QString>(this);
    QObject::connect(watcher, &QFutureWatcher<QString>::finished, this, [this, watcher, callback]() {
        QString returnValue = watcher->result();
        QJSValue cbCopy(callback);
        QJSEngine *engine = qjsEngine(this);
        cbCopy.call(QJSValueList { engine->toScriptValue(returnValue) });
        watcher->deleteLater();
    });
    watcher->setFuture(QtConcurrent::run( [=]() {
        return saveChanges(keysFound, doSign);
    }));
}
