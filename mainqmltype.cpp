#include "mainqmltype.h"
#include <QTimer>
#include <QFontDatabase>
#include <QtConcurrent>
#include "InputType/InputTypeType.h"
#include "RunShellCmd.h"

MainQmlType::MainQmlType(
                         QSplitter *s,
                         QMenu *autoTypeFields,
                         QAction *autoTypeSelected,
                         QAction *autoTypeTimeout,
                         QObject *parent)
    : JsAsync(parent)
    , splitter{s}
    , autoTypeFields{autoTypeFields}
    , autoTypeSelected{autoTypeSelected}
    , autoTypeTimeout{autoTypeTimeout}
{
    passHelper = getInterfacePassHelper(getIsRnPgp());
    passHelper->setPasswordCallback([&](std::string keyid) { return getPasswordFromMap(keyid); });
    passFile = passHelper->getPassFile("");
    watchWaitAndNoneWaitRunCmd->callback = [&]() {
        QStringList waitString, noneWaitString;

        for (auto &itm : watchWaitAndNoneWaitRunCmd->getWaitItemsUids()) {
            waitString.push_back(QString::fromStdString(itm));
        }
        for (auto &itm : watchWaitAndNoneWaitRunCmd->getNoneWaitItemsUids()) {
            noneWaitString.push_back(QString::fromStdString(itm));
        }
        setWaitItems(waitString);
        setNoneWaitItems(noneWaitString);
    };
    loadTreeView();
    connect(autoTypeSelected, &QAction::triggered, autoTypeFields, [=]() {
        autoType(m_selectedText);
    });
    autoTypeSelected->setVisible(false);

    connect(&m_gpgIdManageType,
            &GpgIdManageType::loginRequestedRnpG,
            this,
            [=](const RnpLoginRequestException &e) {
                emit loginRequestedRnp(e, &loginAndPasswordMap);
            });
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
    passHelper = getPrivatePasswordHelper();
    passFile = passHelper->getPassFile(m_filePath.toStdString());
    try {
        m_gpgIdManageType.init(m_filePath.toStdString(),
                               appSettings.passwordStorePath().toStdString(),
                               getIsRnPgp());
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

        try {
            passHelper->searchDown(rootFolderToSearch.toStdString(),
                                   FolderToSearch.toStdString(),
                                   fileRegExStr.toStdString(),
                                   stdExtentions,
                                   isMemCash,
                                   searchMemCash,
                                   [&](std::string path) {
                                       result_strings.push_back(QString::fromStdString(path));
                                   });

        } catch (RnpLoginRequestException &rlre) {
            rlre.functionName = "doSearch";
            emit loginRequestedRnp(rlre, &loginAndPasswordMap);
        } catch (...) {
            throw;
        }
        result_strings.sort(Qt::CaseInsensitive);
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
                               appSettings.passwordStorePath().toStdString(),
                               getIsRnPgp());
        if (!appSettings.ctxSigner().isEmpty()) {
            passHelper->setCtxSigners({appSettings.ctxSigner().split(" ")[0].toStdString()});            
        }
    } catch (...) {
        qDebug() << "Bad signer Id \n"; // Block of code to handle errors
    }
}

void MainQmlType::submit_AppSettingsType(QString passwordStorePath, QString tmpFolderPath, QString gitExecPath, QString vscodeExecPath, QString autoTypeCmd,
                                         QString binaryExts,
                                         bool useClipboard, bool doSign, bool preferYamlView, QString fontSize,
                                         QString commitMsg,
                                         QString ddListStores,
                                         QString ctxSigner)
{
    QString orgStorePath = appSettings.passwordStorePath();
    appSettings.setPasswordStorePath(passwordStorePath);
    appSettings.setTmpFolderPath(tmpFolderPath);

    appSettings.setGitExecPath(gitExecPath);
    appSettings.setVscodeExecPath(vscodeExecPath);
    appSettings.setAutoTypeCmd(autoTypeCmd);
    appSettings.setBinaryExts(binaryExts);
    appSettings.setUseClipboard(useClipboard);
    appSettings.setDoSign(doSign);
    appSettings.setPreferYamlView(preferYamlView);
    appSettings.setFontSize(fontSize);
    appSettings.setCommitMsg(commitMsg);
    appSettings.setDdListStores(ddListStores);
    appSettings.setCtxSigner(ctxSigner);

    loadTreeView();
    if (orgStorePath != appSettings.passwordStorePath()){
        setTreeViewSelected(appSettings.passwordStorePath());
    }
    emit appSettingsTypeChanged();
}

void MainQmlType::setTreeViewSelected(QString path)
{
    emit setTreeviewCurrentIndex(path);
}

void MainQmlType::toggleFilepan()
{
    static QByteArray splitaerState;
    static int prvSize;

    if (m_filePanSize == 0) {
        initFileSystemModel(filePath());        
        splitter->restoreState(splitaerState);
        setFilePanSize(prvSize);
    } else {
        splitaerState = splitter->saveState();
        appSettings.setAppSplitter(splitaerState);
        prvSize = filePanSize();
        splitter->setSizes(QList<int>({0, 400}));
        setFilePanSize(0);
    }
}

bool MainQmlType::isGpgFile(){
    return passFile->isGpgFile();
}

void MainQmlType::doLogout()
{
    QClipboard *clipboard = QGuiApplication::clipboard();
    clipboard->clear();
    loginAndPasswordMap = {};

    setMenubarCommStr("clearSearchFields");

    QString rootPath = appSettings.passwordStorePath();
    setTreeViewSelected(rootPath);

    auto full_path = appSettings.getFindExecutable("gpgconf");

    if (full_path.isEmpty()) {
        qDebug() << "could not found gpgconf";
        return;
    }
    QProcess::startDetached(full_path,
                            QStringList() << "--kill"
                                          << "gpg-agent");
}

InterfaceLibgpgfactory *MainQmlType::getPrivatePasswordHelper()
{
    InterfaceLibgpgfactory *phLocal = getInterfacePassHelper(getIsRnPgp());
    try {
        if (!appSettings.ctxSigner().isEmpty()) {
            phLocal->setCtxSigners({appSettings.ctxSigner().split(" ")[0].toStdString()});
        }
    } catch (...) {
        qDebug() << "Bad signer Id \n"; // Block of code to handle errors
    }
    return phLocal;
}

void MainQmlType::encrypt(QString s)
{
    if (passFile->isGpgFile()) {
        runSafeFromException(
            [&]() {
                // It worth opening dedicated gpg session for stability
                InterfaceLibgpgfactory *phLocal = getPrivatePasswordHelper();
                std::unique_ptr<InterfacePassFile> pfLocal = phLocal->getPassFile(passFile->getFullPath());

                try {
                    pfLocal->encrypt(s.toStdString(),
                                     m_gpgIdManageType.getEncryptTo(), appSettings.doSign());

                } catch (RnpLoginRequestException &rlre) {
                    rlre.functionName = "encrypt";
                    rlre.fromFilePath = s.toStdString();
                    emit loginRequestedRnp(rlre, &loginAndPasswordMap);
                } catch (...) {
                    throw;
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
        //Validate decryption possible, because on diswoned thread exception
        // handling will not work.
        try {
            passFile->decrypt();
        } catch (RnpLoginRequestException &rlre) {
            rlre.functionName = "openExternalEncryptWait";
            emit loginRequestedRnp(rlre, &loginAndPasswordMap);
            return;
        } catch (...) {
            throw;
        }
        //
        runSafeFromException([&]() {
            passFile
                ->openExternalEncryptWaitAsync(m_gpgIdManageType.getEncryptTo(),
                                               watchWaitAndNoneWaitRunCmd.get(),
                                               appSettings.tmpFolderPath().toStdString(),
                                               appSettings.vscodeExecPath().toStdString(),
                                               appSettings.doSign(),
                                               appSettings.ctxSigner().split(" ")[0].toStdString());
        });
    }
}


void MainQmlType::showFolderEncryptNoWait() {
    if (passFile->isGpgFile()) {
        runSafeFromException([&]() {
            std::string subfolderPath
                = watchWaitAndNoneWaitRunCmd->getNoneWaitItemsBuUiniqueId(passFile->getFullPath())->getSubfolderPath().u8string();
            QDesktopServices::openUrl(
                QUrl::fromLocalFile(QString::fromStdString(subfolderPath)));
        });
    }
}

void MainQmlType::discardChangesEncryptNoWait() {
    if (passFile->isGpgFile()) {
        runSafeFromException([&]() {
            watchWaitAndNoneWaitRunCmd->closeWithoutWaitItem(passFile->getFullPath());
        });
    }
}

void MainQmlType::openExternalEncryptNoWait()
{
    if (passFile->isGpgFile()) {
        runSafeFromException([&]() {
            std::string subfolderPath
                = passFile->openExternalEncryptNoWait(watchWaitAndNoneWaitRunCmd.get(),
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
                                                 watchWaitAndNoneWaitRunCmd.get(),
                                                 appSettings.doSign());
        });
    }
}

QString MainQmlType::getDecrypted()
{
    if (passFile->isGpgFile()) {
        QString ret = "";
        runSafeFromException([&]() {
            try {
                passFile->decrypt();
            } catch (RnpLoginRequestException &rlre) {
                rlre.functionName = "getDecrypted";
                emit loginRequestedRnp(rlre, &loginAndPasswordMap);
                QString rootPath = appSettings.passwordStorePath();
                setTreeViewSelected(rootPath);
            } catch (...) {
                throw;
            }

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
            passFile->encryptStringToFile(s, p.u8string(), m_gpgIdManageType.getEncryptTo(),appSettings.doSign());
        });
    } else {
        runSafeFromException([&]() {
            std::filesystem::path  t = templatePath.toStdString();
            t = t / "template.gpg";
            std::filesystem::copy_file(t,p);
        });
    }

    try {
        emit initFileSystemModel(QString::fromStdString(p.u8string()));
        setFilePath(QString::fromStdString(p.u8string()));
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

void MainQmlType::encryptUploadAsync(const QJSValue &callback, QString  fullPathFolder, QStringList fileNames, bool toFilesSubFolder){
    makeAsync<int>(callback,[=]() {
        std::filesystem::path selectFile{};
        for (const QString &fileName : fileNames) {
            encryptUpload(fullPathFolder, fileName, toFilesSubFolder);
            selectFile = fullPathFolder.toStdString();
            QFileInfo  f{fileName};

            selectFile = selectFile / (f.fileName().toStdString() + ".gpg");
        }

        setFilePath(appSettings.passwordStorePath());
        emit initFileSystemModel(QString::fromStdString(selectFile.u8string()));
        return 0;
    });
}

void MainQmlType::encryptUpload(QString fullPathFolder, QString fileName, bool toFilesSubFolder)
{
    const QUrl url(fileName);
    const QString sourceName = url.toLocalFile();

    runSafeFromException([&]() {
        std::filesystem::path source = {sourceName.toStdString()};
        std::filesystem::path dest{fullPathFolder.toStdString()};
        if (toFilesSubFolder) {
            dest = dest / "_files";
            if (!std::filesystem::exists(dest)){
                std::filesystem::create_directory(dest);
            }
        }
        std::string fname = source.filename().u8string();
        fname = fname + ".gpg";
        dest = dest / fname;

        try {
            passFile->encryptFileToFile(sourceName.toStdString(),
                                        dest.u8string(),
                                        m_gpgIdManageType.getEncryptTo(),
                                        appSettings.doSign());
        } catch (RnpLoginRequestException &rlre) {
            rlre.functionName = "encryptUpload";
            rlre.fromFilePath = fullPathFolder.toStdString();
            rlre.toFilePath = fileName.toStdString();
            rlre.doSign = toFilesSubFolder;
            emit loginRequestedRnp(rlre, &loginAndPasswordMap);
        } catch (...) {
            throw;
        }
    });
}

void MainQmlType::decryptDownloadAsync(const QJSValue &callback,QString toFileName){
    makeAsync<int>(callback,[=]() {
        decryptDownload(toFileName);
        return 0;
    });
}

void MainQmlType::decryptDownload(QString toFileName)
{
    const QUrl url(toFileName);
    runSafeFromException([&]() { passFile->decryptToFile(url.toLocalFile().toStdString()); });
}

void MainQmlType::dectyptFileNameToFileNameAsync(const QJSValue &callback,QString fromFileName, QString toFileName){
    makeAsync<int>(callback,[=]() {
        dectyptFileNameToFileName(fromFileName,toFileName);
        return 0;
    });
}

void MainQmlType::dectyptFileNameToFileName(QString fromFileName, QString toFileName)
{
    const QUrl url(toFileName);
    runSafeFromException([&]() { passFile->dectyptFileNameToFileName(fromFileName.toStdString(),  url.toLocalFile().toStdString()); });
}

void MainQmlType::decryptFolderDownloadAsync(const QJSValue &callback, QString fullPathFolder, QString toFolderName){
    makeAsync<int>(callback,[=]() {
        decryptFolderDownload(fullPathFolder, toFolderName);
        return 0;
    });
}

void MainQmlType::decryptFolderDownload(QString fullPathFolder, QString toFolderName)
{
    const QUrl url(toFolderName);
    runSafeFromException([&]() {
        try {
            passHelper->decryptFolderToFolder(fullPathFolder.toStdString(),
                                              url.toLocalFile().toStdString());
        } catch (RnpLoginRequestException &rlre) {
            rlre.functionName = "decryptFolderDownload";
            rlre.fromFilePath = fullPathFolder.toStdString();
            rlre.toFilePath = toFolderName.toStdString();
            emit loginRequestedRnp(rlre, &loginAndPasswordMap);
        } catch (...) {
            throw;
        }
    });
}

void MainQmlType::encryptFolderUpload(QString fromFolderName, QString fullPathFolder)
{
    const QUrl url(fromFolderName);
    runSafeFromException([&]() {
        try {
            passHelper->encryptFolderToFolder(url.toLocalFile().toStdString(),
                                              fullPathFolder.toStdString(),
                                              m_gpgIdManageType.getEncryptTo(),
                                              appSettings.doSign());
        } catch (RnpLoginRequestException &rlre) {
            rlre.functionName = "encryptFolderUpload";
            rlre.fromFilePath = fromFolderName.toStdString();
            rlre.toFilePath = fullPathFolder.toStdString();
            emit loginRequestedRnp(rlre, &loginAndPasswordMap);
        } catch (...) {
            throw;
        }
    });
}

void MainQmlType::encryptFolderUploadAsync(const QJSValue &callback, QString fromFolderName, QString fullPathFolder){
    makeAsync<int>(callback,[=]() {
        encryptFolderUpload(fromFolderName, fullPathFolder);
        emit initFileSystemModel(fullPathFolder);
        return 0;
    });
}

void MainQmlType::runGitSyncCmdAsync(const QJSValue &callback, QString nearestGit, QString syncMsg){
    makeAsync<int>(callback,[=]() {
        runGitSyncCmd(nearestGit, syncMsg);
        return 0;
    });
}

void MainQmlType::runGitSyncCmd(QString nearestGit, QString syncMsg){
    runCmd({appSettings.gitExecPath(),
            "-C",
            nearestGit,
            "add",
            "."
            }," 2>&1");

    runCmd({appSettings.gitExecPath(),
               "-C",
               nearestGit,
               "commit", "-am", syncMsg
           }," 2>&1");
    runCmd({appSettings.gitExecPath(),
               "-C", nearestGit, "pull"
           }," 2>&1");
    runCmd({appSettings.gitExecPath(),
               "-C", nearestGit, "push"
           }," 2>&1");
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

int MainQmlType::runSystem(QStringList keysFound, QString noEscaped)
{
    RunShellCmd rsc;
    std::vector<std::string> v{};
    for (const QString &r : keysFound) {
        v.push_back(r.toStdString());
    }
    return rsc.runSystem(v, noEscaped.toStdString());
}



void MainQmlType::trayMenuAdd(QString _username, QString _password, QString _fieldstype)
{
    QAction *a = new QAction(_username, autoTypeFields);
    connect(a, &QAction::triggered, autoTypeFields, [=]() {
        QString username = _username;
        QString password = _password;
        QString fieldstype = _fieldstype;
        if (fieldstype == "totp") {
            autoType(InputTypeType::getTotp(password));
        } else {
            autoType(password);
        }
    });
    autoTypeFields->addAction(a);
}

void MainQmlType::renameGpgFile(QString filePathFrom, QString filePathTo){
    if (filePathFrom.trimmed() == filePathTo.trimmed()){return;}
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
    std::string rel =  std::filesystem::relative(destination, appSettings.passwordStorePath().toStdString()).u8string();
    if(QString::fromStdString(rel).startsWith(".")){return;};

    emit setTreeviewCurrentIndex(QString::fromStdString(destination.u8string()));
}

void MainQmlType::clipboardRelPath(QString path1, QString path2)
{
    const std::filesystem::path base{path1.toStdWString()},
        to{path2.toStdString()};
    QString s=QString::fromStdString( std::filesystem::relative(to, base).generic_string());

    QGuiApplication::clipboard()->setText(s);

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
    int timeout = 0;
    if (autoTypeTimeout->isChecked()){
        timeout = 3000;
    }
    QTimer::singleShot(timeout, this, [=]{
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
    });

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
