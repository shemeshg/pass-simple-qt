#pragma once

#include <QObject>
#include <qqmlregistration.h>
#include "totp.h"
#include <QSharedPointer>

class InputTypeType : public QObject
{
    Q_OBJECT
    // hygen Q_PROPERTY
    QML_ELEMENT

public:
    explicit InputTypeType(QObject *parent = nullptr) : QObject(parent){};

    // hygen public

    Q_INVOKABLE QString   getTotp(QString secret) {
        if (secret.startsWith("otpauth://totp/")){
            QSharedPointer<Totp::Settings>  settings {Totp::parseSettings(secret,"")};
            return Totp::generateTotp(settings);
        }
        QSharedPointer<Totp::Settings>  settings {Totp::parseSettings("",secret)};
        return Totp::generateTotp(settings);
    }

signals:
    // hygen signals

private:
    // hygen private
};


