#pragma once

#include <QObject>
#include <qqmlregistration.h>
#include "totp.h"
#include <QSharedPointer>
#include <algorithm>
#include <string>

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

    Q_INVOKABLE void autoType (QString sequence){
        std::string s = R"V0G0N(
osascript -e 'tell application "System Events" to keystroke "sequence"'
)V0G0N";

          s = ReplaceAll(s,"sequence",sequence.toStdString());
        system(s.c_str());
    }

signals:
    // hygen signals

private:
    // hygen private

    std::string ReplaceAll(std::string str, const std::string& from, const std::string& to) {
        size_t start_pos = 0;
        while((start_pos = str.find(from, start_pos)) != std::string::npos) {
            str.replace(start_pos, from.length(), to);
            start_pos += to.length(); // Handles case where 'to' is a substring of 'from'
        }
        return str;
    }
};


