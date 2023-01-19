#pragma once

#include <QObject>
#include <qqmlregistration.h>

#include "GpgIdManage.h"

class GpgIdManageType : public QObject
{
  Q_OBJECT  
  Q_PROPERTY(QString currentPath READ currentPath CONSTANT )
  Q_PROPERTY(QString stopPath READ stopPath CONSTANT )
  Q_PROPERTY(QString nearestGpgIdFolder READ nearestGpgIdFolder CONSTANT )
  Q_PROPERTY(QString gpgPubKeysFolder READ gpgPubKeysFolder CONSTANT )
  Q_PROPERTY(QString nearestGpgIdFile READ nearestGpgIdFile CONSTANT )
  Q_PROPERTY(QStringList  keysNotFoundInGpgIdFile READ keysNotFoundInGpgIdFile CONSTANT)
  Q_PROPERTY(QStringList  keysFoundInGpgIdFile READ keysFoundInGpgIdFile CONSTANT)
  Q_PROPERTY(QStringList  allKeys READ allKeys CONSTANT)
  // hygen Q_PROPERTY
  QML_ELEMENT

public:
  explicit GpgIdManageType(QObject *parent = nullptr) : QObject(parent){};
 
    void init(std::string _currentPath, std::string _stopPath, PassHelper *_ph){
        m_gpgIdManage.init(_currentPath, _stopPath, _ph);

    }

  QString currentPath()
  {
    return QString::fromStdString(m_gpgIdManage.currentPath);
  };


  QString stopPath()
  {
    return QString::fromStdString(m_gpgIdManage.stopPath);
  };


  QString nearestGpgIdFolder()
  {
    return QString::fromStdString(m_gpgIdManage.nearestGpgIdFolder);
  };


  QString gpgPubKeysFolder()
  {
    return QString::fromStdString(m_gpgIdManage.gpgPubKeysFolder);
  };

  QString nearestGpgIdFile()
  {
    return QString::fromStdString(m_gpgIdManage.nearestGpgIdFile);
  };


  QStringList  keysNotFoundInGpgIdFile()
  {
    QStringList l;
    for (auto r : m_gpgIdManage.KeysNotFoundInGpgIdFile){
        l.append(QString::fromStdString(r));
    }
    return l;
  };


  QStringList  keysFoundInGpgIdFile()
  {
      QStringList l;
      for (auto r : m_gpgIdManage.keysFoundInGpgIdFile){
          l.append(QString::fromStdString(r.getKeyStr()));
      }
      return l;
  };

  QStringList  allKeys()
  {
      QStringList l;
      for (auto r : m_gpgIdManage.allKeys){
          l.append(QString::fromStdString(r.getKeyStr()));
      }
      return l;
  };


signals:
  void keysNotFoundInGpgIdFileChanged();
  void keysFoundInGpgIdFileChanged();
  void allKeysChanged();
  // hygen signals

private:
  // hygen private
    GpgIdManage m_gpgIdManage;
};

