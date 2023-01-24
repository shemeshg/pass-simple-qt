#include "mainqmltype.h"

#include <qstring.h>



MainQmlType::MainQmlType(QSplitter *s ,QObject *parent) :
    QObject(parent), splitter{s}
{    

    watchWaitAndNoneWaitRunCmd.callback = [&](){
        qDebug()<<"Opened files\n";
        for (auto &itm : watchWaitAndNoneWaitRunCmd.waitItems) {
            qDebug()<<QString::fromStdString( itm.uniqueId)<<"\n";
        }

    };
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
    passFile = passHelper.getPassFile(m_filePath.toStdString());
    try {
      m_gpgIdManageType.init(m_filePath.toStdString(), "/Users/osx/.password-store",&passHelper);
    }
    catch (...) {
     qDebug()<<"Just failed \n"; // Block of code to handle errors
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


