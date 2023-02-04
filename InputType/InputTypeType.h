#pragma once

#include <QObject>
#include <qqmlregistration.h>
#include <QSharedPointer>
#include <algorithm>
#include <string>
#include <qdebug.h>

class InputTypeType : public QObject
{
    Q_OBJECT
    // hygen Q_PROPERTY
    QML_ELEMENT

public:
    explicit InputTypeType(QObject *parent = nullptr) : QObject(parent){};

    // hygen public





signals:
    // hygen signals

private:
    // hygen private



};


