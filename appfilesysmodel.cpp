#include "appfilesysmodel.h"
#include <QUrl>
#include <QMimeData>

AppFileSysModel::AppFileSysModel(QObject *parent)
    : QFileSystemModel{parent}
{

}


Qt::ItemFlags AppFileSysModel::flags(const QModelIndex &index) const
{
    Qt::ItemFlags defaultFlags = QFileSystemModel::flags(index);

    if (!index.isValid()) {
        return defaultFlags;
    }

    const QFileInfo &fileInfo = this->fileInfo(index);

    if (fileInfo.isDir()) { // The target
        // allowed drop
        return Qt::ItemIsDropEnabled | defaultFlags;
    } else if (fileInfo.isFile()) { // The source: should be directory (in that case)
        // allowed drag
        return Qt::ItemIsDragEnabled | defaultFlags;
    }

    return defaultFlags;
}

bool AppFileSysModel::dropMimeData(const QMimeData *data, Qt::DropAction action, int row, int column, const QModelIndex &parent)
{
    const QFileInfo &dropTo = this->fileInfo(parent);

    if (data->hasUrls()) {
        foreach (QUrl url, data->urls())
        {
            qDebug()<<"From "<< url.toLocalFile();
        }
    }


    qDebug() << "To "<<dropTo.filePath();
    return true;
}



