#pragma once

#include <QObject>
#include <qqmlregistration.h>

class DropdownWithListType : public QObject
{
  Q_OBJECT  
  Q_PROPERTY(QString shalomOlam READ shalomOlam WRITE setShalomOlam NOTIFY shalomOlamChanged)
  // hygen Q_PROPERTY
  QML_ELEMENT

public:
  explicit DropdownWithListType(QObject *parent = nullptr) : QObject(parent){};
 
  QString shalomOlam()
  {
    return "from c+++ dropdown backend"; //m_shalomOlam;
  };

  void setShalomOlam(const QString &shalomOlam)
  {
    if (shalomOlam == m_shalomOlam)
      return;

    m_shalomOlam = shalomOlam;
    emit shalomOlamChanged();
  }
  // hygen public

signals:
  void shalomOlamChanged();
  // hygen signals

private:
  QString m_shalomOlam;
  // hygen private
};


