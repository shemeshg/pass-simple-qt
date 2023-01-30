#ifndef MAINQMLTYPE_H
#define MAINQMLTYPE_H
#include <QDesktopServices>
#include <QObject>
#include <QSplitter>
#include <QTreeView>
#include <qqmlregistration.h>

#include "GpgIdManageType.h"
#include "libpasshelper.h"

#include "AppSettings.h"
#include <QFileSystemModel>
#include <QInputEvent>
#include <QModelIndex>

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
  // hygen Q_PROPERTY
  QML_ELEMENT

public:
  explicit MainQmlType(QFileSystemModel *filesystemModel, QTreeView *treeView,
                       QSplitter *s, QObject *parent = nullptr);

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
  // hygen public

  GpgIdManageType *gpgIdManageType() { return &m_gpgIdManageType; }

  Q_INVOKABLE void submit_AppSettingsType(QString passwordStorePath,
                                          QString tmpFolderPath) {
    appSettings.setPasswordStorePath(passwordStorePath);
    appSettings.setTmpFolderPath(tmpFolderPath);
    loadTreeView();
    emit appSettingsTypeChanged();
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
            appSettings.tmpFolderPath().toStdString());
      });
    }
  }

  Q_INVOKABLE void openExternalEncryptNoWait() {
    if (passFile->isGpgFile()) {
      runSafeFromException([&]() {
        std::string subfolderPath = passFile->openExternalEncryptNoWait(
            &watchWaitAndNoneWaitRunCmd,
            appSettings.tmpFolderPath().toStdString());
        QDesktopServices::openUrl(
            QUrl::fromLocalFile(QString::fromStdString(subfolderPath)));
      });
    }
  }

  Q_INVOKABLE void openStoreInFileBrowser() {
    runSafeFromException([&]() {
      QDesktopServices::openUrl(
          QUrl::fromLocalFile(appSettings.passwordStorePath()));
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
      passFile->encryptStringToFile("", p, m_gpgIdManageType.getEncryptTo());
    });
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

signals:
  void filePathChanged();
  void filePanSizeChanged();
  void waitItemsChanged();
  void noneWaitItemsChanged();
  void exceptionCounterChanged();
  void exceptionStrChanged();
  void appSettingsTypeChanged();
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
};

#endif // MAINQMLTYPE_H
