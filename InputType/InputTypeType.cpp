#include "InputTypeType.h"

#include "totp.h"

QString InputTypeType::getTotp(QString secret)
{
    if (secret.startsWith("otpauth://totp/")) {
        QSharedPointer<Totp::Settings> settings{Totp::parseSettings(secret, "")};
        return Totp::generateTotp(settings);
    }
    QSharedPointer<Totp::Settings> settings{Totp::parseSettings("", secret)};
    return Totp::generateTotp(settings);
}
