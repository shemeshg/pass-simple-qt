#ifndef MAINQMLTYPE_H
#define MAINQMLTYPE_H
#include <qqmlregistration.h>
#include <QSplitter>
#include <QObject>

#include "libpasshelper.h"
#include "GpgIdManageType.h"

#include <QInputEvent>

class UiGuard : public QObject
{
public:
    UiGuard(QWidget * ui)
        : widget(ui)
    {
        widget->grabMouse();
        widget->grabKeyboard();
        widget->installEventFilter(this);
    }

    ~UiGuard() override
    {
        widget->releaseKeyboard();
        widget->releaseMouse();
    }

    bool eventFilter(QObject *, QEvent * event) override
    {
        return dynamic_cast<QInputEvent *>(event);  // Eat up the input events
    }

private:
    QWidget * widget;
};

class MainQmlType : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString filePath READ filePath WRITE setFilePath NOTIFY filePathChanged)
    Q_PROPERTY(int filePanSize READ filePanSize WRITE setFilePanSize NOTIFY filePanSizeChanged)
    Q_PROPERTY(GpgIdManageType* gpgIdManageType READ gpgIdManageType CONSTANT)
    Q_PROPERTY(QStringList waitItems READ waitItems WRITE setWaitItems NOTIFY waitItemsChanged)
    Q_PROPERTY(QStringList noneWaitItems READ noneWaitItems WRITE setNoneWaitItems NOTIFY noneWaitItemsChanged)
    // hygen Q_PROPERTY
    QML_ELEMENT

public:
    explicit MainQmlType(QSplitter *s ,QObject *parent = nullptr);

    QString filePath();
    void setFilePath(const QString &filePath);

    int filePanSize();
    void setFilePanSize(const int &filePanSize);

  QStringList waitItems()
  {
    return m_waitItems;
  };

  void setWaitItems(const QStringList &waitItems)
  {
    if (waitItems == m_waitItems)
      return;

    m_waitItems = waitItems;
    emit waitItemsChanged();
  }
  QStringList noneWaitItems()
  {
    return m_noneWaitItems;
  };

  void setNoneWaitItems(const QStringList &noneWaitItems)
  {
    if (noneWaitItems == m_noneWaitItems)
      return;

    m_noneWaitItems = noneWaitItems;
    emit noneWaitItemsChanged();
  }
    // hygen public

    GpgIdManageType* gpgIdManageType(){
        return &m_gpgIdManageType;
    }

    Q_INVOKABLE void toggleFilepan(){
        if (m_filePanSize == 0 ) {
               splitter->setSizes(QList<int>({150  , 400}));
               setFilePanSize(150);
        } else {
            splitter->setSizes(QList<int>({0  , 400}));
            setFilePanSize(0);
        }


    }

    Q_INVOKABLE void encrypt(QString s){
        if (passFile->isGpgFile()){
            passFile->encrypt(s.toStdString(),m_gpgIdManageType.getEncryptTo());
            qDebug()<<"File Encrypted and saved/n";
        }
    }

    Q_INVOKABLE void openExternalEncryptWait(){
        if (passFile->isGpgFile()){

            passFile->openExternalEncryptWaitAsync(m_gpgIdManageType.getEncryptTo(), &watchWaitAndNoneWaitRunCmd);
            qDebug()<<"File Encrypted and saved/n";
        }
    }

    Q_INVOKABLE QString getDecrypted(){        
        if (passFile->isGpgFile()){
            try {
                passFile->decrypt();
                return QString::fromStdString(passFile->getDecrypted());
            } catch (const std::exception& e) {
                qDebug()<<e.what();
                return "";
            }

        }
        else return "";
    }

    Q_INVOKABLE QString getDecryptedSignedBy(){
        if (passFile->isGpgFile()){
            passFile->decrypt();
            return QString::fromStdString(passFile->getDecryptedSignedBy());
        }
        else return "";
    }

    Q_INVOKABLE QString getNearestGit(){

        if (passFile->isGpgFile()){
            return QString::fromStdString(passHelper.getNearestGit(passFile->getFullPath(), "/Users/osx/.password-store"));
        }
        else return "";
    }

    Q_INVOKABLE QString getNearestGpgId(){

        if (passFile->isGpgFile()){            
            return QString::fromStdString(passHelper.getNearestGpgId(passFile->getFullPath(), "/Users/osx/.password-store"));
        }
        else return "";
    }
    


signals:
    void filePathChanged();
    void filePanSizeChanged();
  void waitItemsChanged();
  void noneWaitItemsChanged();
    // hygen signals

private:
    QString m_filePath;
    int m_filePanSize;
    QSplitter *splitter;
    PassHelper passHelper{};
    std::unique_ptr<PassFile> passFile;
    GpgIdManageType m_gpgIdManageType;
    WatchWaitAndNoneWaitRunCmd watchWaitAndNoneWaitRunCmd{};
  QStringList m_waitItems;
  QStringList m_noneWaitItems;
    // hygen private

};

#endif // MAINQMLTYPE_H
