#pragma once
#include <QString>
#include <QSettings>
#include <QDir>
#include <qqmlregistration.h>
#include "config.h"

class AppSettings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString passwordStorePath READ passwordStorePath WRITE setPasswordStorePath NOTIFY passwordStorePathChanged)
    Q_PROPERTY(QString tmpFolderPath READ tmpFolderPath WRITE setTmpFolderPath NOTIFY tmpFolderPathChanged)
  Q_PROPERTY(QString gitExecPath READ gitExecPath WRITE setGitExecPath NOTIFY gitExecPathChanged)
  Q_PROPERTY(QString vscodeExecPath READ vscodeExecPath WRITE setVscodeExecPath NOTIFY vscodeExecPathChanged)
Q_PROPERTY(QString autoTypeCmd READ autoTypeCmd WRITE setAutoTypeCmd NOTIFY autoTypeCmdChanged)
Q_PROPERTY(bool useClipboard READ useClipboard WRITE setUseClipboard NOTIFY useClipboardChanged)

    // hygen Q_PROPERTY
    QML_ELEMENT
public:
    AppSettings(QObject *parent = nullptr) : QObject(parent){

        m_passwordStorePath = settings.value("passwordStorePath", "").toString();
        m_tmpFolderPath = settings.value("tmpFolderPath","").toString();
        m_gitExecPath = settings.value("gitExecPath","").toString();
        m_vscodeExecPath = settings.value("vscodeExecPath","").toString();
        m_autoTypeCmd = settings.value("autoTypeCmd","").toString();
        m_useClipboard = settings.value("useClipboard","").toBool();
        

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

    if (QString(PROJECT_OS) == "LINUX" && QDir( "/dev/shm").exists()){
        tmpFolderPathDefault = "/dev/shm";
    }

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
  
  QString gitExecPath()
  {
    if(m_gitExecPath.isEmpty() ){return "git";}
    return m_gitExecPath;
  };

  void setGitExecPath(const QString &gitExecPath)
  {
    if (gitExecPath == m_gitExecPath)
      return;

    m_gitExecPath = gitExecPath;
    settings.setValue("gitExecPath", m_gitExecPath);

    emit gitExecPathChanged();
  }

  QString vscodeExecPath()
  {
    if(m_vscodeExecPath.isEmpty() ){
        if (QString(PROJECT_OS) == "LINUX"){
            return "/usr/bin/code";
        }
        return "/usr/local/bin/code";
    }
    return m_vscodeExecPath;
  };

  void setVscodeExecPath(const QString &vscodeExecPath)
  {
    if (vscodeExecPath == m_vscodeExecPath)
      return;

    m_vscodeExecPath = vscodeExecPath;
    settings.setValue("vscodeExecPath", m_vscodeExecPath);

    emit vscodeExecPathChanged();
  }

  QString autoTypeCmd()
  {
    if(m_autoTypeCmd.isEmpty() ){
        if (QString(PROJECT_OS) == "LINUX"){
            return R"V0G0N(
echo -n sequence | xclip -selection clipboard
    )V0G0N";
        }
        return "";
    }
    return m_autoTypeCmd;
  };

  void setAutoTypeCmd(const QString &autoTypeCmd)
  {
    if (autoTypeCmd == m_autoTypeCmd)
      return;

    m_autoTypeCmd = autoTypeCmd;
    settings.setValue("autoTypeCmd", m_autoTypeCmd);

    emit autoTypeCmdChanged();
  }

  bool useClipboard()
  {
    return m_useClipboard;
  };

  void setUseClipboard(const bool useClipboard)
  {
    if (useClipboard == m_useClipboard)
      return;

    m_useClipboard = useClipboard;
    settings.setValue("useClipboard", m_useClipboard);

    emit useClipboardChanged();
  }


  // hygen public

  signals:
  void passwordStorePathChanged();
  void tmpFolderPathChanged();
  void gitExecPathChanged();
  void vscodeExecPathChanged();
  void autoTypeCmdChanged();
  void useClipboardChanged();
    // hygen signals

  private:
  QSettings settings{"shemeshg", "PassSimple"};
  QString m_passwordStorePath;
  QString m_tmpFolderPath;
  QString m_gitExecPath;
  QString m_vscodeExecPath;
  QString m_autoTypeCmd;
  bool m_useClipboard;
  // hygen private
};
