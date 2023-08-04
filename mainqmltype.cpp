#include "mainqmltype.h"
#include "InputType/totp.h"
#include <QTimer>
#include <QFontDatabase>
#include <QtConcurrent>


MainQmlType::MainQmlType(
                         QSplitter *s,
                         QMenu *autoTypeFields,
                         QAction *autoTypeSelected,
                         QObject *parent)
    : JsAsync(parent)
    , splitter{s}
    , autoTypeFields{autoTypeFields}
    , autoTypeSelected{autoTypeSelected}

{
    watchWaitAndNoneWaitRunCmd.callback = [&]() {
        QStringList waitString, noneWaitString;

        for (auto &itm : watchWaitAndNoneWaitRunCmd.waitItems) {
            waitString.push_back(QString::fromStdString(itm->uniqueId));
        }
        for (auto &itm : watchWaitAndNoneWaitRunCmd.noneWaitItems) {
            noneWaitString.push_back(QString::fromStdString(itm->uniqueId));
        }
        setWaitItems(waitString);
        setNoneWaitItems(noneWaitString);
    };
    loadTreeView();
    connect(autoTypeSelected, &QAction::triggered, autoTypeFields, [=]() {
        autoType(m_selectedText);
    });
    autoTypeSelected->setVisible(false);
}
QString MainQmlType::filePath()
{
    return m_filePath;
}

void MainQmlType::setFilePath(const QString &filePath)
{
    if (filePath == m_filePath)
        return;

    m_filePath = filePath;
    passHelper = std::make_unique<PassHelper>();
    passFile = passHelper->getPassFile(m_filePath.toStdString());
    try {
        m_gpgIdManageType.init(m_filePath.toStdString(),
                               appSettings.passwordStorePath().toStdString());
    } catch (...) {
        qDebug() << "MainQmlType::setFilePath(const QString &filePath) Just failed \n"; // Block of code to handle errors
    }

    emit filePathChanged();
}

int MainQmlType::filePanSize()
{
    return m_filePanSize;
}

void MainQmlType::setFilePanSize(const int &filePanSize)
{
    if (filePanSize == m_filePanSize)
        return;

    m_filePanSize = filePanSize;
    emit filePanSizeChanged();
}

void MainQmlType::setWaitItems(const QStringList &waitItems)
{
    if (waitItems == m_waitItems)
        return;

    m_waitItems = waitItems;
    emit waitItemsChanged();
}

void MainQmlType::setNoneWaitItems(const QStringList &noneWaitItems)
{
    if (noneWaitItems == m_noneWaitItems)
        return;

    m_noneWaitItems = noneWaitItems;
    emit noneWaitItemsChanged();
}

void MainQmlType::setExceptionCounter(const int &exceptionCounter)
{
    if (exceptionCounter == m_exceptionCounter)
        return;

    m_exceptionCounter = exceptionCounter;
    emit exceptionCounterChanged();
}

void MainQmlType::setExceptionStr(const QString &exceptionStr)
{
    if (exceptionStr == m_exceptionStr)
        return;

    m_exceptionStr = exceptionStr;
    emit exceptionStrChanged();
}

void MainQmlType::setAppSettingsType(AppSettings *appSettingsType)
{
    appSettings.setPasswordStorePath(appSettingsType->passwordStorePath());
    appSettings.setTmpFolderPath(appSettingsType->tmpFolderPath());
    emit appSettingsTypeChanged();
    qDebug() << "Yes subbmited";
}

void MainQmlType::setSearchResult(const QStringList &searchResult)
{
    m_searchResult = searchResult;
    emit searchResultChanged();
}

void MainQmlType::setSelectedText(const QString &selectedText)
{
    if (selectedText == m_selectedText)
        return;

    m_selectedText = selectedText;

    if (m_selectedText.isEmpty()){
        autoTypeSelected->setVisible(false);
    } else {
        autoTypeSelected->setVisible(true);
    }

    emit selectedTextChanged();
}

void MainQmlType::doSearch(QString rootFolderToSearch,
                           QString FolderToSearch,
                           QString fileRegExStr,
                           bool isMemCash)
{
    runSafeFromException([&]() {        
        QStringList result_strings;
        setSearchResult(result_strings);


        QVector<QString> extentions = appSettings.binaryExts().split("\n");
        std::vector<std::string> stdExtentions;
        for (const auto& elem : extentions)
        {
            if (!elem.isEmpty()){
                stdExtentions.push_back(elem.toStdString());
            }
        }

        passHelper->searchDown(rootFolderToSearch.toStdString(),
                               FolderToSearch.toStdString(),
                               fileRegExStr.toStdString(),
                               stdExtentions,
                               isMemCash,
                               searchMemCash,
                               [&](std::string path) {
                                   result_strings.push_back(QString::fromStdString(path));
                               });
        setSearchResult(result_strings);
    });


}

void MainQmlType::doSearchAsync(QString rootFolderToSearch,
                                QString FolderToSearch,
                                QString fileRegExStr,
                                bool isMemCash,
                                const QJSValue &callback)
{
    makeAsync<int>(callback,[=]() {
        doSearch(rootFolderToSearch, FolderToSearch, fileRegExStr, isMemCash);
        return 0;
    });
}

void MainQmlType::initGpgIdManage()
{
    try {
        m_gpgIdManageType.init(appSettings.passwordStorePath().toStdString(),
                               appSettings.passwordStorePath().toStdString());
        if (!appSettings.ctxSigner().isEmpty()) {
            passHelper->setCtxSigners({appSettings.ctxSigner().split(" ")[0].toStdString()});
        }
    } catch (...) {
        qDebug() << "Bad signer Id \n"; // Block of code to handle errors
    }
}

void MainQmlType::submit_AppSettingsType(QString passwordStorePath, QString tmpFolderPath, QString gitExecPath, QString vscodeExecPath, QString autoTypeCmd,
                                         QString binaryExts,
                                         bool useClipboard, bool doSign, bool preferYamlView, QString fontSize, QString ctxSigner)
{
    appSettings.setPasswordStorePath(passwordStorePath);
    appSettings.setTmpFolderPath(tmpFolderPath);

    appSettings.setGitExecPath(gitExecPath);
    appSettings.setVscodeExecPath(vscodeExecPath);
    appSettings.setAutoTypeCmd(autoTypeCmd);
    appSettings.setBinaryExts(binaryExts);
    appSettings.setUseClipboard(useClipboard);
    appSettings.setDoSign(doSign);
    appSettings.setPreferYamlView(preferYamlView);
    appSettings.setfontSize(fontSize);
    appSettings.setCtxSigner(ctxSigner);

    loadTreeView();
    emit appSettingsTypeChanged();
}

void MainQmlType::setTreeViewSelected(QString path)
{
    emit setTreeviewCurrentIndex(path);
}

void MainQmlType::toggleFilepan()
{
    if (m_filePanSize == 0) {
        initFileSystemModel(filePath());
        splitter->setSizes(QList<int>({150, 400}));
        setFilePanSize(150);
    } else {
        splitter->setSizes(QList<int>({0, 400}));
        setFilePanSize(0);
    }
}

void MainQmlType::encrypt(QString s)
{
    if (passFile->isGpgFile()) {
        runSafeFromException(
            [&]() {
                // It worth opening dedicated gpg session for stability
                std::unique_ptr<PassHelper> phLocal = std::make_unique<PassHelper>();
                std::unique_ptr<PassFile> pfLocal = phLocal->getPassFile(passFile->getFullPath());

                try {
                    pfLocal->encrypt(s.toStdString(),
                                     m_gpgIdManageType.getEncryptTo(), appSettings.doSign());
                }
                catch (const std::exception& e) {
                    std::this_thread::sleep_for(std::chrono::seconds(1));
                    pfLocal->encrypt(s.toStdString(),
                                     m_gpgIdManageType.getEncryptTo(), appSettings.doSign());
                }

            });
    }
}

void MainQmlType::encryptAsync(QString s, const QJSValue &callback)
{
    makeAsync<int>(callback,[=]() {
        encrypt(s);
        return 0;
    });
}

void MainQmlType::openExternalEncryptWait()
{
    if (passFile->isGpgFile()) {
        runSafeFromException([&]() {
            passFile->openExternalEncryptWaitAsync(m_gpgIdManageType.getEncryptTo(),
                                                   &watchWaitAndNoneWaitRunCmd,
                                                   appSettings.tmpFolderPath().toStdString(),
                                                   appSettings.vscodeExecPath().toStdString());
        });
    }
}

void MainQmlType::openExternalEncryptNoWait()
{
    if (passFile->isGpgFile()) {
        runSafeFromException([&]() {
            std::string subfolderPath
                    = passFile->openExternalEncryptNoWait(&watchWaitAndNoneWaitRunCmd,
                                                          appSettings.tmpFolderPath().toStdString(),
                                                          appSettings.vscodeExecPath().toStdString());
            QDesktopServices::openUrl(
                        QUrl::fromLocalFile(QString::fromStdString(subfolderPath)));
        });
    }
}

void MainQmlType::openStoreInFileBrowser(QString fullPathFolder)
{
    if (fullPathFolder.isEmpty()) {
        fullPathFolder = appSettings.passwordStorePath();
    }
    runSafeFromException(
                [&]() { QDesktopServices::openUrl(QUrl::fromLocalFile(fullPathFolder)); });
}

void MainQmlType::closeExternalEncryptNoWait()
{
    if (passFile->isGpgFile()) {
        runSafeFromException([&]() {
            passFile->closeExternalEncryptNoWait(m_gpgIdManageType.getEncryptTo(),
                                                 &watchWaitAndNoneWaitRunCmd);
        });
    }
}

QString MainQmlType::getDecrypted()
{
    if (passFile->isGpgFile()) {
        QString ret = "";
        runSafeFromException([&]() {
            passFile->decrypt();
            ret = QString::fromStdString(passFile->getDecrypted());
        });
        return ret;
    } else
        return "";
}

void MainQmlType::getDecryptedAsync(const QJSValue &callback)
{
    makeAsync<QString>(callback,[=]() {
        return getDecrypted();
    });
}

QString MainQmlType::getDecryptedSignedBy()
{
    if (passFile->isGpgFile()) {
        //passFile->decrypt();

        QString ret = "";
        runSafeFromException(
                    [&]() { ret = QString::fromStdString(passFile->getDecryptedSignedBy()); });
        return ret;
    } else
        return "";
}

QString MainQmlType::getNearestGit()
{
    QString ret = "";
    runSafeFromException([&]() {
        ret = QString::fromStdString(
                    passHelper->getNearestGit(passFile->getFullPath(),
                                             appSettings.passwordStorePath().toStdString()));
    });
    return ret;
}

QString MainQmlType::getNearestTemplateGpg()
{
    QString ret = "";
    runSafeFromException([&]() {
        ret = QString::fromStdString(
                    passHelper->getNearestTemplateGpg(passFile->getFullPath(),
                                             appSettings.passwordStorePath().toStdString()));
    });
    return ret;
}

QString MainQmlType::getNearestGpgId()
{
    QString ret = "";
    runSafeFromException([&]() {
        ret = QString::fromStdString(
                    passHelper->getNearestGpgId(passFile->getFullPath(),
                                               appSettings.passwordStorePath().toStdString()));
    });
    return ret;
}

QString MainQmlType::getFullPathFolder()
{
    QString ret = "";
    runSafeFromException([&]() { ret = QString::fromStdString(passFile->getFullPathFolder()); });
    return ret;
}

void MainQmlType::createEmptyEncryptedFile(QString fullPathFolder, QString fileName,  QString templatePath)
{
    std::filesystem::path p = fullPathFolder.toStdString();
    fileName = fileName + ".gpg";
    p = p / fileName.toStdString();

    if (templatePath.isEmpty()){
        runSafeFromException([&]() {
            std::string s = R"V0G0N(user: ""
password: ""
expire: ""
home: ""
totp: ""
description: ""
fields type:
  user: text
  password: password
  expire: datetime
  totp: totp
  home: url
  description: textedit)V0G0N";
            passFile->encryptStringToFile(s, p, m_gpgIdManageType.getEncryptTo());
        });
    } else {
        runSafeFromException([&]() {
            std::filesystem::path  t = templatePath.toStdString();
            t = t / "template.gpg";
            std::filesystem::copy_file(t,p);
        });
    }

    try {
        emit initFileSystemModel(QString::fromStdString(p));
        setFilePath(QString::fromStdString(p));
    } catch (...) {
      qDebug()<<p.c_str()<<" failed";
    }

}

bool MainQmlType::fileExists(QString fullPathFolder, QString fileName)
{
    std::filesystem::path p = fullPathFolder.toStdString();
    fileName = fileName + ".gpg";
    p = p / fileName.toStdString();

    return (std::filesystem::exists(p));
}

void MainQmlType::encryptUpload(QString fullPathFolder, QString fileName)
{
    const QUrl url(fileName);
    const QString sourceName = url.toLocalFile();

    runSafeFromException([&]() {
        std::filesystem::path source = {sourceName.toStdString()};
        std::filesystem::path dest{fullPathFolder.toStdString()};
        std::string fname = source.filename();
        fname = fname + ".gpg";
        dest = dest / fname;
        passFile->encryptFileToFile(sourceName.toStdString(),
                                    dest,
                                    m_gpgIdManageType.getEncryptTo());
    });
}

void MainQmlType::decryptDownload(QString toFileName)
{
    const QUrl url(toFileName);
    runSafeFromException([&]() { passFile->decryptToFile(url.toLocalFile().toStdString()); });
}

void MainQmlType::decryptFolderDownload(QString fullPathFolder, QString toFolderName)
{
    const QUrl url(toFolderName);
    runSafeFromException([&]() {
        passHelper->decryptFolderToFolder(fullPathFolder.toStdString(),
                                         url.toLocalFile().toStdString());
    });
}

void MainQmlType::encryptFolderUpload(QString fromFolderName, QString fullPathFolder)
{
    const QUrl url(fromFolderName);
    runSafeFromException([&]() {
        passHelper->encryptFolderToFolder(url.toLocalFile().toStdString(),
                                         fullPathFolder.toStdString(),
                                         m_gpgIdManageType.getEncryptTo());
    });
}

QString MainQmlType::runCmd(QStringList keysFound, QString noEscaped)
{
    RunShellCmd rsc;
    std::vector<std::string> v{};
    for (const QString &r : keysFound) {
        v.push_back(r.toStdString());
    }
    return QString::fromStdString(rsc.runCmd(v, noEscaped.toStdString()));
}

QString MainQmlType::getTotp(QString secret)
{
    if (secret.startsWith("otpauth://totp/")) {
        QSharedPointer<Totp::Settings> settings{Totp::parseSettings(secret, "")};
        return Totp::generateTotp(settings);
    }
    QSharedPointer<Totp::Settings> settings{Totp::parseSettings("", secret)};
    return Totp::generateTotp(settings);
}

void MainQmlType::trayMenuAdd(QString _username, QString _password, QString _fieldstype)
{
    QAction *a = new QAction(_username, autoTypeFields);
    connect(a, &QAction::triggered, autoTypeFields, [=]() {
        QString username = _username;
        QString password = _password;
        QString fieldstype = _fieldstype;
        if (fieldstype == "totp") {
            autoType(getTotp(password));
        } else {
            autoType(password);
        }
    });
    autoTypeFields->addAction(a);
}

void MainQmlType::renameGpgFile(QString filePathFrom, QString filePathTo){
    std::filesystem::copy(filePathFrom.toStdString(),filePathTo.toStdString());
    emit initFileSystemModel(filePathTo);
    setFilePath(filePathTo);
    std::filesystem::remove(filePathFrom.toStdString());
}

void MainQmlType::tryRedirectLocalLink(QString link)
{
    std::filesystem::path destination = std::filesystem::path( passFile->getFullPathFolder()) ;
    destination = destination / ( link.toStdString() + ".gpg");

    if (!std::filesystem::exists(destination)){return;}
    std::string rel =  std::filesystem::relative(destination, appSettings.passwordStorePath().toStdString());
    if(QString::fromStdString(rel).startsWith(".")){return;};

    emit setTreeviewCurrentIndex(QString::fromStdString(destination));
}

void MainQmlType::runSafeFromException(std::function<void ()> callback)
{
    try {
        callback();
    } catch (const std::exception &e) {
        setExceptionStr(e.what());
        setExceptionCounter(exceptionCounter() + 1);        
    } catch (...) {
    }
}

void MainQmlType::loadTreeView()
{
    emit setRootTreeView(appSettings.passwordStorePath());

}

void MainQmlType::autoType(QString sequence)
{
    if (appSettings.useClipboard()) {
        QClipboard *clipboard = QGuiApplication::clipboard();
        clipboard->setText(sequence);
        return;
    }
#if defined(__linux__)
    std::string s = appSettings.autoTypeCmd().toStdString();
    s = ReplaceAll(s, "sequence", escapeshellarg(sequence.toStdString()));
    system(s.c_str());
    return;
#elif defined(__APPLE__)
    std::string s = R"V0G0N(
osascript -e 'tell application "System Events" to keystroke "sequence"'
)V0G0N";

    s = ReplaceAll(s, "sequence", escapeAppleScript(sequence.toStdString()));
    system(s.c_str());
#endif
}

std::string MainQmlType::ReplaceAll(std::string str, const std::string &from, const std::string &to)
{
    size_t start_pos = 0;
    while ((start_pos = str.find(from, start_pos)) != std::string::npos) {
        str.replace(start_pos, from.length(), to);
        start_pos += to.length(); // Handles case where 'to' is a substring of 'from'
    }
    return str;
}

std::string MainQmlType::escapeshellarg(std::string str)
{
    std::string ret = str;
    ret = ReplaceAll(ret, "\\", "\\\\");
    ret = ReplaceAll(ret, "'", "\\'");
    ret = "'" + str + "'";

    return ret;
}

std::string MainQmlType::escapeAppleScript(std::string str)
{
    std::string ret = str;
    ret = ReplaceAll(ret, "\\", "\\\\");
    ret = ReplaceAll(ret, "'", "'\\''");
    ret = ReplaceAll(ret, R"(")", R"(\")");

    return ret;
}
