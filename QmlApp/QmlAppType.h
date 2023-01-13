#pragma once

#include <QObject>
#include <qqmlregistration.h>

class QmlAppType : public QObject
{
  Q_OBJECT  
  Q_PROPERTY(QString helloWorld READ helloWorld WRITE setHelloWorld NOTIFY helloWorldChanged)
  // hygen Q_PROPERTY
  QML_ELEMENT

public:
  explicit QmlAppType(QObject *parent = nullptr) : QObject(parent){};
 
  QString helloWorld()
  {
    return m_helloWorld;
  };

  void setHelloWorld(const QString &helloWorld)
  {
    if (helloWorld == m_helloWorld)
      return;

    m_helloWorld = helloWorld;
    emit helloWorldChanged();
  }
  // hygen public

signals:
  void helloWorldChanged();
  // hygen signals

private:
  QString m_helloWorld;
  // hygen private
};


