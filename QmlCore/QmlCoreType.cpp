#include "QmlCoreType.h"
#include <QFontDatabase>

QString QmlCoreType::fixedFontSystemName() const
{
    const QFont fixedFont = QFontDatabase::systemFont(QFontDatabase::FixedFont);
    return fixedFont.family();
}
