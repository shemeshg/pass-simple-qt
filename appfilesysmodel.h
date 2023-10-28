#pragma once

#include <QFileSystemModel>

class AppFileSysModel : public QFileSystemModel
{
    Q_OBJECT
public:
    explicit AppFileSysModel(QObject *parent = nullptr);
    Qt::ItemFlags flags(const QModelIndex &index) const;
    bool dropMimeData(const QMimeData *data, Qt::DropAction action, int row, int column, const QModelIndex &parent);
signals:

};


