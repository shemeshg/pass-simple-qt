#pragma once

#include <QDate>
#include <QObject>
#include <qqmlregistration.h>

class DatetimeType : public QObject {
  Q_OBJECT
  Q_PROPERTY(QString datetimeStr READ datetimeStr WRITE setDatetimeStr NOTIFY
                 datetimeStrChanged)
  Q_PROPERTY(
      int daysDiff READ daysDiff WRITE setDaysDiff NOTIFY daysDiffChanged)
  Q_PROPERTY(QString datetimeFormat READ datetimeFormat WRITE setDatetimeFormat NOTIFY datetimeFormatChanged)
  // hygen Q_PROPERTY
  QML_ELEMENT

public:
  explicit DatetimeType(QObject *parent = nullptr) : QObject(parent){

    };

  QString datetimeStr() {
      return m_datetimeStr;
  };

  void setDatetimeStr(const QString &datetimeStr) {
    if (datetimeStr == m_datetimeStr)
      return;
    QDateTime dt = QDateTime::fromString(datetimeStr, m_datetimeFormat);
    if (dt.isNull())
    {
        return;
    }

    m_datetimeStr = datetimeStr;

    emit datetimeStrChanged();

    m_daysDiff = (int)QDateTime::currentDateTime().daysTo(dt);
    emit daysDiffChanged();

  }
  int daysDiff() { return m_daysDiff; };

  void setDaysDiff(const int &daysDiff) {
    if (daysDiff == m_daysDiff)
      return;

    m_daysDiff = daysDiff;
    emit daysDiffChanged();
    m_datetimeStr = QDateTime::currentDateTime().addDays(m_daysDiff).toString(m_datetimeFormat);
    emit datetimeStrChanged();
  }
  QString datetimeFormat()
  {
    return m_datetimeFormat;
  };

  void setDatetimeFormat(const QString &datetimeFormat)
  {
    if (datetimeFormat == m_datetimeFormat)
      return;

    m_datetimeFormat = datetimeFormat;
    m_datetimeStr = nowString();
    emit datetimeFormatChanged();
  }
  // hygen public


signals:
  void datetimeStrChanged();
  void daysDiffChanged();
  void datetimeFormatChanged();
  // hygen signals

private:
  QString m_datetimeStr;
  int m_daysDiff = 0;
  QString m_datetimeFormat;
  // hygen private  
  QString nowString() {
    return QDateTime::currentDateTime().toString(m_datetimeFormat);
  }
};
