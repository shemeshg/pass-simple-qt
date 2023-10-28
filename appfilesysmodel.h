#pragma once

#include <QFileSystemModel>

class AppFileSysModel : public QFileSystemModel
{
    Q_OBJECT
public:
    explicit AppFileSysModel(QObject *parent = nullptr);

signals:

};


