#ifndef MAINQMLTYPE_H
#define MAINQMLTYPE_H
#include <QDesktopServices>
#include <QMenu>
#include <QObject>
#include <QSplitter>
#include <QTreeView>
#include <qqmlregistration.h>

#include "GpgIdManageType.h"
#include "InterfacePassHelper.h"
#include "InterfaceWatchWaitAndNoneWaitRunCmd.h"
#include "RnpLoginRequestException.h"

#include "AppSettings.h"
#include <QClipboard>
#include <QFileSystemModel>
#include <QGuiApplication>
#include <QInputEvent>
#include <QJSEngine>
#include <QMap>
#include <QModelIndex>
#include <QUuid>

#include "JsAsync.h"

class QtRunShellCmd : public RunShellCmd
{
private:
    std::string exec(const char *cmd)
    {
        QString command = QString::fromStdString(cmd);
        QStringList parts = command.split("'");
        QMutableStringListIterator i(parts); // pass list as argument
        while (i.hasNext()) {
            QString str = i.next();
            i.setValue(str.simplified());
            if (str.simplified().isEmpty()) {
                i.remove(); // delete current item
            }
            if (str.simplified() == "2>&1") {
                i.remove();
            }
        }
        QString program = parts.first();
        QStringList arguments = parts.mid(1);

        QProcess pingProcess;
        pingProcess.start(program, {arguments});
        pingProcess.waitForFinished(); // sets current thread to sleep and waits for pingProcess end
        QString output(pingProcess.readAllStandardOutput());
        pingProcess.close();
        return output.toStdString();
    }
};

class MainQmlType : public JsAsync
{
    Q_OBJECT
    Q_PROPERTY(QString filePath READ filePath WRITE setFilePath NOTIFY filePathChanged)
    Q_PROPERTY(int filePanSize READ filePanSize WRITE setFilePanSize NOTIFY filePanSizeChanged)
    Q_PROPERTY(GpgIdManageType *gpgIdManageType READ gpgIdManageType CONSTANT)
    Q_PROPERTY(QStringList waitItems READ waitItems WRITE setWaitItems NOTIFY waitItemsChanged)
    Q_PROPERTY(QStringList noneWaitItems READ noneWaitItems WRITE setNoneWaitItems NOTIFY
               noneWaitItemsChanged)
    Q_PROPERTY(int exceptionCounter READ exceptionCounter WRITE setExceptionCounter NOTIFY
               exceptionCounterChanged)
    Q_PROPERTY(
            QString exceptionStr READ exceptionStr WRITE setExceptionStr NOTIFY exceptionStrChanged)
    Q_PROPERTY(AppSettings *appSettingsType READ appSettingsType WRITE setAppSettingsType NOTIFY
               appSettingsTypeChanged)
    Q_PROPERTY(
            QStringList searchResult READ searchResult WRITE setSearchResult NOTIFY searchResultChanged)
    Q_PROPERTY(QString selectedText READ selectedText WRITE setSelectedText NOTIFY selectedTextChanged)
    Q_PROPERTY(QString menubarCommStr READ menubarCommStr WRITE setMenubarCommStr NOTIFY menubarCommStrChanged)
    // hygen Q_PROPERTY
    QML_ELEMENT

public:
    explicit MainQmlType(
                         QSplitter *s,
                         QMenu *autoTypeFields,
                         QAction *autoTypeSelected,
                        QAction *autoTypeTimeout,
                         QObject *parent = nullptr);

    QString filePath();
    void setFilePath(const QString &filePath);

    int filePanSize();
    void setFilePanSize(const int &filePanSize);

    QStringList waitItems() { return m_waitItems; };

    void setWaitItems(const QStringList &waitItems);
    QStringList noneWaitItems() { return m_noneWaitItems; };

    void setNoneWaitItems(const QStringList &noneWaitItems);
    int exceptionCounter() { return m_exceptionCounter; };

    void setExceptionCounter(const int &exceptionCounter);
    QString exceptionStr() { return m_exceptionStr; };

    void setExceptionStr(const QString &exceptionStr);
    AppSettings *appSettingsType() { return &appSettings; };

    void setAppSettingsType(AppSettings *appSettingsType);
    QStringList &searchResult() { return m_searchResult; };

    void setSearchResult(const QStringList &searchResult);
    QString selectedText()
    {
        return m_selectedText;
    };

    void setSelectedText(const QString &selectedText);
    QString menubarCommStr()
    {
        return m_menubarCommStr;
    };

    void setMenubarCommStr(const QString &menubarCommStr)
    {

        m_menubarCommStr = menubarCommStr + " " + QUuid::createUuid().toString();
        emit menubarCommStrChanged();
    }
    // hygen public

    GpgIdManageType *gpgIdManageType() { return &m_gpgIdManageType; }

    Q_INVOKABLE void doSearch(QString rootFolderToSearch,
                              QString FolderToSearch,
                              QString fileRegExStr,
                              bool isMemCash);

    Q_INVOKABLE void doSearchAsync(QString rootFolderToSearch,
                              QString FolderToSearch,
                              QString fileRegExStr,
                                   bool isMemCash,
                                   const QJSValue &callback);

    Q_INVOKABLE void initGpgIdManage();

    Q_INVOKABLE void submit_AppSettingsType(QString passwordStorePath,
                                            QString tmpFolderPath,
                                            QString gitExecPath,
                                            QString rnpgpHome,
                                            QString vscodeExecPath,
                                            QString autoTypeCmd,
                                            QString binaryExts,
                                            bool useClipboard,
                                            bool allowScreenCapture,
                                            bool useRnpgp,
                                            bool doSign,
                                            bool preferYamlView,
                                            QString fontSize,
                                            QString commitMsg,
                                            QString ddListStores,
                                            QString ctxSigner);

    Q_INVOKABLE void setTreeViewSelected(QString path);

    Q_INVOKABLE void toggleFilepan();

    Q_INVOKABLE void encrypt(QString s);

    Q_INVOKABLE void encryptAsync(QString s,
                                   const QJSValue &callback);

    Q_INVOKABLE void openExternalEncryptWait();

    Q_INVOKABLE void openExternalEncryptNoWait();

    Q_INVOKABLE void openStoreInFileBrowser(QString fullPathFolder);

    Q_INVOKABLE void closeExternalEncryptNoWait();
    Q_INVOKABLE void showFolderEncryptNoWait();
    Q_INVOKABLE void discardChangesEncryptNoWait();

    Q_INVOKABLE QString getDecrypted();
    Q_INVOKABLE void getDecryptedAsync(const QJSValue &callback);

    Q_INVOKABLE QString getDecryptedSignedBy();

    Q_INVOKABLE QString getNearestGit();

    Q_INVOKABLE QString getNearestTemplateGpg();

    Q_INVOKABLE QString getNearestGpgId();

    Q_INVOKABLE QString getFullPathFolder();

    Q_INVOKABLE void createEmptyEncryptedFile(QString fullPathFolder, QString fileName, QString templatePath);

    Q_INVOKABLE bool fileExists(QString fullPathFolder, QString fileName);

    Q_INVOKABLE void encryptUpload(QString fullPathFolder, QString fileName, bool toFilesSubFolder=false);

    Q_INVOKABLE void encryptUploadAsync(const QJSValue &callback, QString  fullPathFolder, QStringList  fileName, bool toFilesSubFolder=false);

    Q_INVOKABLE void decryptDownload(QString toFileName);

    Q_INVOKABLE void decryptDownloadAsync(const QJSValue &callback, QString toFileName);

    Q_INVOKABLE void dectyptFileNameToFileName(QString fromFileName,QString toFileName);

    Q_INVOKABLE void dectyptFileNameToFileNameAsync(const QJSValue &callback, QString fromFileName, QString toFileName);

    Q_INVOKABLE void decryptFolderDownload(QString fullPathFolder, QString toFolderName);

    Q_INVOKABLE void decryptFolderDownloadAsync(const QJSValue &callback, QString fullPathFolder, QString toFolderName);

    Q_INVOKABLE void encryptFolderUpload(QString fromFolderName, QString fullPathFolder);

    Q_INVOKABLE void encryptFolderUploadAsync(const QJSValue &callback, QString fromFolderName, QString fullPathFolder);

    Q_INVOKABLE QString runCmd(QStringList keysFound, QString noEscaped);

    Q_INVOKABLE int runSystem(QStringList keysFound, QString noEscaped);


    Q_INVOKABLE void trayMenuClear() { autoTypeFields->clear(); }

    Q_INVOKABLE void trayMenuAdd(QString _username, QString _password, QString _fieldstype);

    Q_INVOKABLE void renameGpgFile(QString filePathFrom, QString filePathTo);

    Q_INVOKABLE void tryRedirectLocalLink(QString link);

    Q_INVOKABLE void doMainUiDisable(){
        emit mainUiDisable();
    }

    Q_INVOKABLE void doMainUiEnable(){
        emit mainUiEnable();
    }

    Q_INVOKABLE void clipboardRelPath(QString path1, QString path2);

    Q_INVOKABLE void runGitSyncCmd(QString nearestGit, QString syncMsg);

    Q_INVOKABLE void runGitSyncCmdAsync(const QJSValue &callback, QString nearestGit, QString syncMsg);
    Q_INVOKABLE bool isGpgFile();

    Q_INVOKABLE void doLogout();

    std::string getKeyDescription(std::string strFind)
    {
        auto l = passHelper->listKeys(strFind, false);
        if (l.size() > 0) {
            return l.at(0).getKeyStr();
        }
        l = passHelper->listKeys(strFind, true);
        if (l.size() > 0) {
            return l.at(0).getKeyStr();
        }
        return strFind;
    }

signals:
    void filePathChanged();
    void filePanSizeChanged();
    void waitItemsChanged();
    void noneWaitItemsChanged();
    void exceptionCounterChanged();
    void exceptionStrChanged();
    void appSettingsTypeChanged();
    void searchResultChanged();
    void selectedTextChanged();
    void menubarCommStrChanged();
    void mainUiDisable();
    void mainUiEnable();
    void initFileSystemModel(QString filePath);
    void setTreeviewCurrentIndex(QString path);
    void setRootTreeView(QString path);
    void systemPlateChanged(bool isDarkTheme);
    void loginRequestedRnp(const RnpLoginRequestException &e, std::map<std::string, std::string> *m);
    // hygen signals

private:
    AppSettings appSettings{};
    QString m_filePath;
    int m_filePanSize;
    QSplitter *splitter;
    InterfaceLibgpgfactory *passHelper = nullptr;
    std::unique_ptr<InterfacePassFile> passFile = nullptr;
    GpgIdManageType m_gpgIdManageType;
    std::unique_ptr<InterfaceWatchWaitAndNoneWaitRunCmd> watchWaitAndNoneWaitRunCmd = getInterfaceWatchWaitAndNoneWaitRunCmd();
    QStringList m_waitItems;
    QStringList m_noneWaitItems;
    int m_exceptionCounter = 0;
    QString m_exceptionStr;
    QMenu *autoTypeFields;
    QAction *autoTypeSelected;
    QAction *autoTypeTimeout;

    QStringList m_searchResult;
    QString m_selectedText;
    QString m_menubarCommStr;

    std::unique_ptr<RunShellCmd> runShellCmd = std::make_unique<QtRunShellCmd>();
    // hygen private

    void runSafeFromException(std::function<void()> callback);

    void loadTreeView();

    void autoType(QString sequence);

    std::string ReplaceAll(std::string str, const std::string &from, const std::string &to);

    std::string escapeshellarg(std::string str);

    std::string escapeAppleScript(std::string str);

    std::map<std::string, std::string> searchMemCash;

    InterfaceLibgpgfactory *getPrivatePasswordHelper();

    std::map<std::string, std::string> loginAndPasswordMap{};
    std::string getPasswordFromMap(std::string keyid)
    {
        std::string pass = "";
        if (loginAndPasswordMap.count(keyid)) {
            pass = loginAndPasswordMap.at(keyid);
        }
        return pass;
    }
};

#endif // MAINQMLTYPE_H
