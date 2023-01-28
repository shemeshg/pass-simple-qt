#pragma once
#include <QString>
#include <QSettings>
#include <QDir>
#include <qqmlregistration.h>

class AppSettings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString passwordStorePath READ passwordStorePath WRITE setPasswordStorePath NOTIFY passwordStorePathChanged)
    Q_PROPERTY(QString tmpFolderPath READ tmpFolderPath WRITE setTmpFolderPath NOTIFY tmpFolderPathChanged)
    // hygen Q_PROPERTY
    QML_ELEMENT
public:
    AppSettings(QObject *parent = nullptr) : QObject(parent){

        m_passwordStorePath = settings.value("passwordStorePath", "").toString();
        m_tmpFolderPath = settings.value("tmpFolderPath","").toString();
    }




  QString passwordStorePath()
  {
      QString passwordStorePathDefault = QDir::homePath() + "/.password-store";
     if(m_passwordStorePath.isEmpty() || !QDir( m_passwordStorePath).exists()){return passwordStorePathDefault;}

    return m_passwordStorePath;
  };

  void setPasswordStorePath(const QString &passwordStorePath)
  {
    if (passwordStorePath == m_passwordStorePath)
      return;

    m_passwordStorePath = passwordStorePath;
    settings.setValue("passwordStorePath", m_passwordStorePath);
  }
  
  QString tmpFolderPath()
  {

    QString tmpFolderPathDefault = QDir::tempPath();
    if(m_tmpFolderPath.isEmpty() || !QDir( m_tmpFolderPath).exists() ){return tmpFolderPathDefault;}
    return m_tmpFolderPath;
  };

  void setTmpFolderPath(const QString &tmpFolderPath)
  {
    if (tmpFolderPath == m_tmpFolderPath)
      return;

    m_tmpFolderPath = tmpFolderPath;
    settings.setValue("tmpFolderPath", m_tmpFolderPath);
  }
  
  // hygen public

  signals:
  void passwordStorePathChanged();
  void tmpFolderPathChanged();
    // hygen signals

  private:
  QSettings settings{"shemeshg", "PassSimple"};
  QString m_passwordStorePath;
  QString m_tmpFolderPath;
  // hygen private
};
