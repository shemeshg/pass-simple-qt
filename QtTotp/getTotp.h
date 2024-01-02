#include <QObject>
#include <QSharedPointer>
#include <qdebug.h>
#include <qqmlregistration.h>
#include "totp.h"

QString getTotpf(QString secret)
{
    if (secret.startsWith("otpauth://totp/")) {
        QSharedPointer<Totp::Settings> settings{Totp::parseSettings(secret, "")};
        return Totp::generateTotp(settings);
    }
    QSharedPointer<Totp::Settings> settings{Totp::parseSettings("", secret)};
    return Totp::generateTotp(settings);
}
