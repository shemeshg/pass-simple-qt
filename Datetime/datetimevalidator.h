#include <QValidator>
#include <QDateTime>
#include <qqmlregistration.h>

class DateTimeValidator: public QValidator
{
    Q_OBJECT
  Q_PROPERTY(QString datetimeFormat READ datetimeFormat WRITE setDatetimeFormat NOTIFY datetimeFormatChanged)
    // hygen Q_PROPERTY
    QML_ELEMENT
public:
    DateTimeValidator();

    State validate(QString& input, int& pos) const;

  QString datetimeFormat()
  {
    return m_datetimeFormat;
  };

  void setDatetimeFormat(const QString &datetimeFormat)
  {
    if (datetimeFormat == m_datetimeFormat)
      return;

    m_datetimeFormat = datetimeFormat;
    emit datetimeFormatChanged();
  }
  // hygen public

signals:
  void datetimeFormatChanged();
  // hygen signals

private:    
  QString m_datetimeFormat;
// hygen private
};
