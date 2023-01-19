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


  // hygen public

signals:
  // hygen signals

private:
  // hygen private
    GpgIdManage m_gpgIdManage;
};

