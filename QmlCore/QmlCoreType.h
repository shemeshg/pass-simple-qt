#pragma once

#include <QObject>
#include <qqmlregistration.h>

class QmlCoreType : public QObject
{
  Q_OBJECT  
  // hygen Q_PROPERTY
  Q_PROPERTY(QString fixedFontSystemName READ fixedFontSystemName CONSTANT)
  QML_ELEMENT

public:
  explicit QmlCoreType(QObject *parent = nullptr) : QObject(parent){};

  // hygen public

  QString fixedFontSystemName() const;

  signals:
  // hygen signals

private:
    // hygen private
};
