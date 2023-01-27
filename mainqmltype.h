#ifndef MAINQMLTYPE_H
#define MAINQMLTYPE_H
#include <qqmlregistration.h>
#include <QSplitter>
#include <QObject>
#include <QDesktopServices>

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
    Q_PROPERTY(int exceptionCounter READ exceptionCounter WRITE setExceptionCounter NOTIFY exceptionCounterChanged)
    Q_PROPERTY(QString exceptionStr READ exceptionStr WRITE setExceptionStr NOTIFY exceptionStrChanged)
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
    int exceptionCounter()
    {
        return m_exceptionCounter;
    };

    void setExceptionCounter(const int &exceptionCounter)
    {
        if (exceptionCounter == m_exceptionCounter)
            return;

        m_exceptionCounter = exceptionCounter;
        emit exceptionCounterChanged();
    }
    QString exceptionStr()
    {
        return m_exceptionStr;
    };

    void setExceptionStr(const QString &exceptionStr)
    {
        if (exceptionStr == m_exceptionStr)
            return;

        m_exceptionStr = exceptionStr;
        emit exceptionStrChanged();
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
            runSafeFromException( [&](){
                passFile->encrypt(s.toStdString(),m_gpgIdManageType.getEncryptTo());
            });
        }
    }

    Q_INVOKABLE void openExternalEncryptWait(){
        if (passFile->isGpgFile()){            
            runSafeFromException( [&](){
                passFile->openExternalEncryptWaitAsync(m_gpgIdManageType.getEncryptTo(), &watchWaitAndNoneWaitRunCmd);
            });
        }
    }

    Q_INVOKABLE void openExternalEncryptNoWait(){
        if (passFile->isGpgFile()){            
            runSafeFromException( [&](){
                std::string subfolderPath = passFile->openExternalEncryptNoWait(&watchWaitAndNoneWaitRunCmd);
                QDesktopServices::openUrl(QUrl::fromLocalFile(QString::fromStdString(subfolderPath)));
            });

        }
    }

    Q_INVOKABLE void openStoreInFileBrowser(){
        runSafeFromException( [&](){
             QDesktopServices::openUrl(QUrl::fromLocalFile("/Users/osx/.password-store"));
        });
    }

    Q_INVOKABLE void closeExternalEncryptNoWait(){
        if (passFile->isGpgFile()){

            runSafeFromException( [&](){
                passFile->closeExternalEncryptNoWait(
                            m_gpgIdManageType.getEncryptTo(),
                            &watchWaitAndNoneWaitRunCmd);
            });



        }
    }

    Q_INVOKABLE QString getDecrypted(){
        if (passFile->isGpgFile()){


            QString ret = "";
            runSafeFromException( [&](){
                passFile->decrypt();
                ret = QString::fromStdString(passFile->getDecrypted());
            });
            return ret;
        }
        else return "";
    }

    Q_INVOKABLE QString getDecryptedSignedBy(){
        if (passFile->isGpgFile()){
            passFile->decrypt();

            QString ret = "";
            runSafeFromException( [&](){
                ret = QString::fromStdString(passFile->getDecryptedSignedBy());
            });
            return ret;
        }
        else return "";
    }

    Q_INVOKABLE QString getNearestGit(){

        if (passFile->isGpgFile()){
            QString ret = "";
            runSafeFromException( [&](){
                ret = QString::fromStdString(passHelper.getNearestGit(passFile->getFullPath(), "/Users/osx/.password-store"));
            });
            return ret;
        }
        else return "";
    }

    Q_INVOKABLE QString getNearestGpgId(){

        if (passFile->isGpgFile()){

            QString ret = "";
            runSafeFromException( [&](){
                ret = QString::fromStdString(passHelper.getNearestGpgId(passFile->getFullPath(), "/Users/osx/.password-store"));
            });
            return ret;
        }
        else return "";
    }
    


signals:
    void filePathChanged();
    void filePanSizeChanged();
    void waitItemsChanged();
    void noneWaitItemsChanged();
    void exceptionCounterChanged();
    void exceptionStrChanged();
    // hygen signals

private:
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
    // hygen private

    void runSafeFromException(std::function<void()> callback){
        try {
            callback();
        } catch (const std::exception& e) {
            setExceptionStr(e.what());
            setExceptionCounter(exceptionCounter()+1);
        } catch (...) {            
        }
    }



};

#endif // MAINQMLTYPE_H
