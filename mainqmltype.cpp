#include "mainqmltype.h"

#include <qstring.h>

MainQmlType::MainQmlType(QFileSystemModel *filesystemModel,
                         QTreeView *treeView,
                         QSplitter *s,
                         QMenu *autoTypeFields,
                         QObject *parent)
    : QObject(parent)
    , splitter{s}
    , treeView{treeView}
    , filesystemModel{filesystemModel}
    , autoTypeFields{autoTypeFields}
{
    watchWaitAndNoneWaitRunCmd.callback = [&]() {
        QStringList waitString, noneWaitString;

        for (auto &itm : watchWaitAndNoneWaitRunCmd.waitItems) {
            waitString.push_back(QString::fromStdString(itm.uniqueId));
        }
        for (auto &itm : watchWaitAndNoneWaitRunCmd.noneWaitItems) {
            noneWaitString.push_back(QString::fromStdString(itm.uniqueId));
        }
        setWaitItems(waitString);
        setNoneWaitItems(noneWaitString);
    };
    loadTreeView();
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
    passFile->setFullPath(m_filePath.toStdString());
    try {
        m_gpgIdManageType.init(m_filePath.toStdString(),
                               appSettings.passwordStorePath().toStdString(),
                               &passHelper);
    } catch (...) {
        qDebug() << "Just failed \n"; // Block of code to handle errors
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
