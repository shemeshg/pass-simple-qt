#pragma once
#include <QString>
#include <QSettings>
#include <QDir>

class AppSettings
{
public:
    AppSettings(){
        m_passwordStorePath = settings.value("passwordStorePath", QDir::homePath() + "/.password-store").toString();
        m_tmpFolderPath = settings.value("tmpFolderPath",QDir::tempPath()).toString();
        QString s{};
    }

  AppSettings(AppSettings const &) = delete;
  AppSettings &operator=(AppSettings const &) = delete;
  AppSettings(AppSettings &&) = delete;
  AppSettings &operator=(AppSettings &&) = delete;

  ~AppSettings(){};

  QString passwordStorePath()
  {
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
  private:
  QSettings settings{"shemeshg", "PassSimple"};
  QString m_passwordStorePath;
  QString m_tmpFolderPath;
  // hygen private
};
