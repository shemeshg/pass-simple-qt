#include "InputTypeType.h"

#include "QtTotp/getTotp.h"

QString InputTypeType::getTotp(QString secret)
{
    return getTotpf(secret);
}
