#pragma once

#include <QObject>
#include <qqmlregistration.h>

class QmlAppType : public QObject
{
  Q_OBJECT  
  // hygen Q_PROPERTY
  QML_ELEMENT

public:
  explicit QmlAppType(QObject *parent = nullptr) : QObject(parent){};
 
  // hygen public

signals:
  // hygen signals

private:
  // hygen private
};


