#include "datetimevalidator.h"

DateTimeValidator::DateTimeValidator(): QValidator()
{}

QValidator::State DateTimeValidator::validate(QString& input, int& pos) const
{
     QDateTime dt = QDateTime::fromString(input, m_datetimeFormat);
     if (dt.isNull())
     {
         return QValidator::Intermediate;
     }
     return QValidator::Acceptable;
}
