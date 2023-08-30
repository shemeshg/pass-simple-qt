#pragma once

#include <QObject>
#include <qqmlregistration.h>

class QmlCoreType : public QObject
{
  Q_OBJECT  
  // hygen Q_PROPERTY
  QML_ELEMENT

public:
  explicit QmlCoreType(QObject *parent = nullptr) : QObject(parent){};
 
  // hygen public

signals:
  // hygen signals

private:
  // hygen private
};


