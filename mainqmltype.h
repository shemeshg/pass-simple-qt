#ifndef MAINQMLTYPE_H
#define MAINQMLTYPE_H
#include <qqmlregistration.h>
#include <QSplitter>
#include <QObject>

#include "libpasshelper.h"

class MainQmlType : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString filePath READ filePath WRITE setFilePath NOTIFY filePathChanged)
    Q_PROPERTY(int filePanSize READ filePanSize WRITE setFilePanSize NOTIFY filePanSizeChanged)
    QML_ELEMENT

public:
    explicit MainQmlType(QSplitter *s ,QObject *parent = nullptr);

    QString filePath();
    void setFilePath(const QString &filePath);

    int filePanSize();
    void setFilePanSize(const int &filePanSize);

    Q_INVOKABLE void toggleFilepan(){
        if (m_filePanSize == 0 ) {
               splitter->setSizes(QList<int>({150  , 400}));
               setFilePanSize(150);
        } else {
            splitter->setSizes(QList<int>({0  , 400}));
            setFilePanSize(0);
        }


    }

    Q_INVOKABLE QString getDecrypted(){        
        if (passFile->isGpgFile()){
            passFile->decrypt();
            return QString::fromStdString(passFile->getDecrypted());
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

private:
    QString m_filePath;
    int m_filePanSize;
    QSplitter *splitter;
    PassHelper passHelper{};
    std::unique_ptr<PassFile> passFile;

};

#endif // MAINQMLTYPE_H
