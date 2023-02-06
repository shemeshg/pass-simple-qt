#ifndef MAINQMLTYPE_H
#define MAINQMLTYPE_H
#include <QDesktopServices>
#include <QObject>
#include <QSplitter>
#include <QTreeView>
#include <QMenu>
#include <qqmlregistration.h>

#include "GpgIdManageType.h"
#include "libpasshelper.h"

#include "AppSettings.h"
#include "InputType/totp.h"
#include <QFileSystemModel>
#include <QInputEvent>
#include <QModelIndex>
#include <QClipboard>
#include <QGuiApplication>
#include "config.h"

class MainQmlType : public QObject {
  Q_OBJECT
  Q_PROPERTY(
      QString filePath READ filePath WRITE setFilePath NOTIFY filePathChanged)
  Q_PROPERTY(int filePanSize READ filePanSize WRITE setFilePanSize NOTIFY
                 filePanSizeChanged)
  Q_PROPERTY(GpgIdManageType *gpgIdManageType READ gpgIdManageType CONSTANT)
  Q_PROPERTY(QStringList waitItems READ waitItems WRITE setWaitItems NOTIFY
                 waitItemsChanged)
  Q_PROPERTY(QStringList noneWaitItems READ noneWaitItems WRITE setNoneWaitItems
                 NOTIFY noneWaitItemsChanged)
  Q_PROPERTY(int exceptionCounter READ exceptionCounter WRITE
                 setExceptionCounter NOTIFY exceptionCounterChanged)
  Q_PROPERTY(QString exceptionStr READ exceptionStr WRITE setExceptionStr NOTIFY
                 exceptionStrChanged)
  Q_PROPERTY(AppSettings *appSettingsType READ appSettingsType WRITE
                 setAppSettingsType NOTIFY appSettingsTypeChanged)
  Q_PROPERTY(QStringList searchResult READ searchResult WRITE setSearchResult NOTIFY searchResultChanged)
  // hygen Q_PROPERTY
  QML_ELEMENT

public:
  explicit MainQmlType(QFileSystemModel *filesystemModel, QTreeView *treeView,
                       QSplitter *s, QMenu* autoTypeFields, QObject *parent = nullptr);

  QString filePath();
  void setFilePath(const QString &filePath);

  int filePanSize();
  void setFilePanSize(const int &filePanSize);

  QStringList waitItems() { return m_waitItems; };

  void setWaitItems(const QStringList &waitItems) {
    if (waitItems == m_waitItems)
      return;

    m_waitItems = waitItems;
    emit waitItemsChanged();
  }
  QStringList noneWaitItems() { return m_noneWaitItems; };

  void setNoneWaitItems(const QStringList &noneWaitItems) {
    if (noneWaitItems == m_noneWaitItems)
      return;

    m_noneWaitItems = noneWaitItems;
    emit noneWaitItemsChanged();
  }
  int exceptionCounter() { return m_exceptionCounter; };

  void setExceptionCounter(const int &exceptionCounter) {
    if (exceptionCounter == m_exceptionCounter)
      return;

    m_exceptionCounter = exceptionCounter;
    emit exceptionCounterChanged();
  }
  QString exceptionStr() { return m_exceptionStr; };

  void setExceptionStr(const QString &exceptionStr) {
    if (exceptionStr == m_exceptionStr)
      return;

    m_exceptionStr = exceptionStr;
    emit exceptionStrChanged();
  }
  AppSettings *appSettingsType() { return &appSettings; };

  void setAppSettingsType(AppSettings *appSettingsType) {

    appSettings.setPasswordStorePath(appSettingsType->passwordStorePath());
    appSettings.setTmpFolderPath(appSettingsType->tmpFolderPath());
    emit appSettingsTypeChanged();
    qDebug() << "Yes subbmited";
  }
  QStringList &searchResult()
  {
    return m_searchResult;
  };

  void setSearchResult(const QStringList &searchResult)
  {
    m_searchResult = searchResult;
    emit searchResultChanged();
  }
  // hygen public

  GpgIdManageType *gpgIdManageType() { return &m_gpgIdManageType; }

  Q_INVOKABLE void doSearch(QString FolderToSearch, QString fileRegExStr){

        m_searchResult.clear();
        emit searchResultChanged();
      passHelper.searchDown(appSettings.passwordStorePath().toStdString(),
                            FolderToSearch.toStdString(),
                            fileRegExStr.toStdString(),
                            [&](std::string path)
                              {
                m_searchResult.push_back(QString::fromStdString(path));
                emit searchResultChanged();
      });



  }

  Q_INVOKABLE void submit_AppSettingsType(QString passwordStorePath,
                                          QString tmpFolderPath,
                                          QString gitExecPath,
                                          QString vscodeExecPath,
                                          QString autoTypeCmd,
                                          bool useClipboard) {
    appSettings.setPasswordStorePath(passwordStorePath);
    appSettings.setTmpFolderPath(tmpFolderPath);

    appSettings.setGitExecPath(gitExecPath);
    appSettings.setVscodeExecPath(vscodeExecPath);
    appSettings.setAutoTypeCmd(autoTypeCmd);
    appSettings.setUseClipboard(useClipboard);
    
    loadTreeView();
    emit appSettingsTypeChanged();
  }

  Q_INVOKABLE void setTreeViewSelected(QString path){
      treeView->setCurrentIndex(filesystemModel->index(path));
  }

  Q_INVOKABLE void toggleFilepan() {
    if (m_filePanSize == 0) {
      splitter->setSizes(QList<int>({150, 400}));
      setFilePanSize(150);
    } else {
      splitter->setSizes(QList<int>({0, 400}));
      setFilePanSize(0);
    }
  }

  Q_INVOKABLE void encrypt(QString s) {
    if (passFile->isGpgFile()) {
      runSafeFromException([&]() {
        passFile->encrypt(s.toStdString(), m_gpgIdManageType.getEncryptTo());
      });
    }
  }

  Q_INVOKABLE void openExternalEncryptWait() {
    if (passFile->isGpgFile()) {
      runSafeFromException([&]() {
        passFile->openExternalEncryptWaitAsync(
            m_gpgIdManageType.getEncryptTo(), &watchWaitAndNoneWaitRunCmd,
            appSettings.tmpFolderPath().toStdString(),
            appSettings.vscodeExecPath().toStdString()  );
      });
    }
  }

  Q_INVOKABLE void openExternalEncryptNoWait() {
    if (passFile->isGpgFile()) {
      runSafeFromException([&]() {
        std::string subfolderPath = passFile->openExternalEncryptNoWait(
            &watchWaitAndNoneWaitRunCmd,
            appSettings.tmpFolderPath().toStdString(),
            appSettings.vscodeExecPath().toStdString()        );
        QDesktopServices::openUrl(
            QUrl::fromLocalFile(QString::fromStdString(subfolderPath)));
      });
    }
  }

  Q_INVOKABLE void openStoreInFileBrowser(QString fullPathFolder) {
    if (fullPathFolder.isEmpty()){
        fullPathFolder = appSettings.passwordStorePath();
    }
      runSafeFromException([&]() {
      QDesktopServices::openUrl(
          QUrl::fromLocalFile(fullPathFolder));
    });
  }

  Q_INVOKABLE void closeExternalEncryptNoWait() {
    if (passFile->isGpgFile()) {

      runSafeFromException([&]() {
        passFile->closeExternalEncryptNoWait(m_gpgIdManageType.getEncryptTo(),
                                             &watchWaitAndNoneWaitRunCmd);
      });
    }
  }

  Q_INVOKABLE QString getDecrypted() {
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

  Q_INVOKABLE QString getDecryptedSignedBy() {
    if (passFile->isGpgFile()) {
      passFile->decrypt();

      QString ret = "";
      runSafeFromException([&]() {
        ret = QString::fromStdString(passFile->getDecryptedSignedBy());
      });
      return ret;
    } else
      return "";
  }

  Q_INVOKABLE QString getNearestGit() {
    QString ret = "";
    runSafeFromException([&]() {
      ret = QString::fromStdString(passHelper.getNearestGit(
          passFile->getFullPath(),
          appSettings.passwordStorePath().toStdString()));
    });
    return ret;
  }

  Q_INVOKABLE QString getNearestGpgId() {
    QString ret = "";
    runSafeFromException([&]() {
      ret = QString::fromStdString(passHelper.getNearestGpgId(
          passFile->getFullPath(),
          appSettings.passwordStorePath().toStdString()));
    });
    return ret;
  }

  Q_INVOKABLE QString getFullPathFolder() {
    QString ret = "";
    runSafeFromException(
        [&]() { ret = QString::fromStdString(passFile->getFullPathFolder()); });
    return ret;
  }

  Q_INVOKABLE void createEmptyEncryptedFile(QString fullPathFolder,
                                            QString fileName) {
    std::filesystem::path p = fullPathFolder.toStdString();
    fileName = fileName + ".gpg";
    p = p / fileName.toStdString();

    runSafeFromException([&]() {
        std::string s = R"V0G0N(user name: ""
password: ""
home page: ""
totp: ""
description: ""
fields type:
  user name: text
  password: password
  totp: totp
  home page: url
  description: textedit)V0G0N";
      passFile->encryptStringToFile(s, p, m_gpgIdManageType.getEncryptTo());
    });
  }

  Q_INVOKABLE bool fileExists(QString fullPathFolder,
                                            QString fileName) {
    std::filesystem::path p = fullPathFolder.toStdString();
    fileName = fileName + ".gpg";
    p = p / fileName.toStdString();

    return (std::filesystem::exists(p));
  }


  Q_INVOKABLE void encryptUpload(QString fullPathFolder, QString fileName) {
      const QUrl url(fileName);
      const QString sourceName = url.toLocalFile();

    runSafeFromException([&]() {
      std::filesystem::path source = {sourceName.toStdString()};
      std::filesystem::path dest{fullPathFolder.toStdString()};
      std::string fname = source.filename();
      fname = fname + ".gpg";
      dest = dest / fname;
      passFile->encryptFileToFile(sourceName.toStdString(), dest,
                                  m_gpgIdManageType.getEncryptTo());
    });
  }

  Q_INVOKABLE void decryptDownload(QString toFileName) {
      const QUrl url(toFileName);
    runSafeFromException(
        [&]() { passFile->decryptToFile(url.toLocalFile().toStdString()); });
  }

  Q_INVOKABLE QString runCmd(QStringList keysFound, QString noEscaped){
      RunShellCmd rsc;
      std::vector<std::string> v{};
      for (const QString &r : keysFound){
          v.push_back(r.toStdString());
      }
      return QString::fromStdString( rsc.runCmd(v, noEscaped.toStdString()) );

  }

  Q_INVOKABLE QString   getTotp(QString secret) {
      if (secret.startsWith("otpauth://totp/")){
          QSharedPointer<Totp::Settings>  settings {Totp::parseSettings(secret,"")};
          return Totp::generateTotp(settings);
      }
      QSharedPointer<Totp::Settings>  settings {Totp::parseSettings("",secret)};
      return Totp::generateTotp(settings);
  }

  Q_INVOKABLE void trayMenuClear(){
    autoTypeFields->clear();
  }

  Q_INVOKABLE void trayMenuAdd(QString _username, QString _password, QString _fieldstype){
    QAction *a = new QAction(_username, autoTypeFields);
    connect(a, &QAction::triggered, autoTypeFields, [=](  ) {
       QString username = _username;
       QString password = _password;
       QString fieldstype = _fieldstype;
       if (fieldstype == "totp"){
           autoType(getTotp(password));
       } else {
           autoType(password);
       }

    });
    autoTypeFields->addAction(a);

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
  // hygen signals

private:
  AppSettings appSettings{};
  QString m_filePath;
  int m_filePanSize;
  QSplitter *splitter;
  PassHelper passHelper{};
  std::unique_ptr<PassFile> passFile = passHelper.getPassFile("");
  GpgIdManageType m_gpgIdManageType;
  WatchWaitAndNoneWaitRunCmd watchWaitAndNoneWaitRunCmd{};
  QStringList m_waitItems;
  QStringList m_noneWaitItems;
  int m_exceptionCounter = 0;
  QString m_exceptionStr;
  QTreeView *treeView;
  QFileSystemModel *filesystemModel;
  QMenu *autoTypeFields;

  QStringList m_searchResult;
  // hygen private

  void runSafeFromException(std::function<void()> callback) {
    try {
      callback();
    } catch (const std::exception &e) {
      setExceptionStr(e.what());
      setExceptionCounter(exceptionCounter() + 1);
    } catch (...) {
    }
  }

  void loadTreeView() {
    QString rootPath = appSettings.passwordStorePath();

    if (!rootPath.isEmpty()) {
      const QModelIndex rootIndex =
          filesystemModel->index(QDir::cleanPath(rootPath));
      if (rootIndex.isValid())
        treeView->setRootIndex(rootIndex);
    }
  }

  void autoType (QString sequence){
      if (appSettings.useClipboard()){
          QClipboard *clipboard = QGuiApplication::clipboard();
          clipboard->setText(sequence);
          return;
      }
      if (QString(PROJECT_OS) == "LINUX"){
          std::string s =appSettings.autoTypeCmd().toStdString();

          s = ReplaceAll(s,"sequence",escapeshellarg(sequence.toStdString()));
          system(s.c_str());
          return;
      }
      if (QString(PROJECT_OS) == "MACOSX"){
      std::string s = R"V0G0N(
osascript -e 'tell application "System Events" to keystroke "sequence"'
)V0G0N";

        s = ReplaceAll(s,"sequence",escapeAppleScript(sequence.toStdString()));
        system(s.c_str());
      }
  }

  std::string ReplaceAll(std::string str, const std::string& from, const std::string& to) {
      size_t start_pos = 0;
      while((start_pos = str.find(from, start_pos)) != std::string::npos) {
          str.replace(start_pos, from.length(), to);
          start_pos += to.length(); // Handles case where 'to' is a substring of 'from'
      }
      return str;
  }

  std::string escapeshellarg(std::string str)
  {
    std::string ret = str;
    ret = ReplaceAll(ret, "\\", "\\\\");
    ret = ReplaceAll(ret, "'", "\\'");
    ret = "'" + str + "'";

    return ret;
  }

  std::string escapeAppleScript(std::string str)
  {
    std::string ret = str;
    ret = ReplaceAll(ret, "\\", "\\\\");
    ret = ReplaceAll(ret, "'", "'\\''");
    ret = ReplaceAll(ret, R"(")" , R"(\")");

    return ret;
  }
};

#endif // MAINQMLTYPE_H
