#ifndef MAINQMLTYPE_H
#define MAINQMLTYPE_H
#include <QDesktopServices>
#include <QMenu>
#include <QObject>
#include <QSplitter>
#include <QTreeView>
#include <qqmlregistration.h>

#include "GpgIdManageType.h"
#include "libpasshelper.h"

#include "AppSettings.h"
#include <QClipboard>
#include <QFileSystemModel>
#include <QGuiApplication>
#include <QInputEvent>
#include <QModelIndex>
#include <QUuid>
#include <QJSEngine>

#include "JsAsync.h"

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
                                            QString vscodeExecPath,
                                            QString autoTypeCmd,
                                            QString binaryExts,
                                            bool useClipboard,
                                            bool doSign,
                                            bool preferYamlView,
                                            QString fontSize,
                                            QString commitMsg,
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

    Q_INVOKABLE QString runCmd(QStringList keysFound, QString noEscaped);

    Q_INVOKABLE int runSystem(QStringList keysFound, QString noEscaped);

    Q_INVOKABLE QString getTotp(QString secret);

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
    // hygen signals

private:
    AppSettings appSettings{};
    QString m_filePath;
    int m_filePanSize;
    QSplitter *splitter;
    std::unique_ptr<PassHelper> passHelper = std::make_unique<PassHelper>();
    std::unique_ptr<PassFile> passFile = passHelper->getPassFile("");
    GpgIdManageType m_gpgIdManageType;
    WatchWaitAndNoneWaitRunCmd watchWaitAndNoneWaitRunCmd{};
    QStringList m_waitItems;
    QStringList m_noneWaitItems;
    int m_exceptionCounter = 0;
    QString m_exceptionStr;
    QMenu *autoTypeFields;
    QAction *autoTypeSelected;

    QStringList m_searchResult;
    QString m_selectedText;
    QString m_menubarCommStr;
    // hygen private

    void runSafeFromException(std::function<void()> callback);

    void loadTreeView();

    void autoType(QString sequence);

    std::string ReplaceAll(std::string str, const std::string &from, const std::string &to);

    std::string escapeshellarg(std::string str);

    std::string escapeAppleScript(std::string str);

    std::map<std::string, std::string> searchMemCash;

};

#endif // MAINQMLTYPE_H
