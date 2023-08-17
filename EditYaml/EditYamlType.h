#pragma once

#include <yaml-cpp/yaml.h>
#include <string>
#include <QDebug>
#include <QObject>
#include <QVariantMap>
#include <qqmlregistration.h>

class EditYamlType : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
    Q_PROPERTY(bool isYamlValid READ isYamlValid WRITE setIsYamlValid NOTIFY isYamlValidChanged)
    Q_PROPERTY(
        QString yamlErrorMsg READ yamlErrorMsg WRITE setYamlErrorMsg NOTIFY yamlErrorMsgChanged)
    Q_PROPERTY(QVariantList yamlModel READ yamlModel WRITE setYamlModel NOTIFY yamlModelChanged)
    QML_ELEMENT

public:
    explicit EditYamlType(QObject *parent = nullptr)
        : QObject(parent){};

    const QString &text() const { return m_text; };

    void setText(const QString &text);
    bool isYamlValid() const { return m_isYamlValid; };

    void setIsYamlValid(const bool &isYamlValid);
    QString yamlErrorMsg() { return m_yamlErrorMsg; };

    void setYamlErrorMsg(const QString &yamlErrorMsg);
    const QVariantList &yamlModel() const { return m_yamlModel; };
    void setYamlModel(const QVariantList &yamlModel);

    Q_INVOKABLE QString getUpdatedText();
    Q_INVOKABLE void sendChangeVal(QString key, QString val);

signals:
    void textChanged();
    void isYamlValidChanged();
    void yamlErrorMsgChanged();
    void yamlModelChanged();

private:
    QString m_text;
    bool m_isYamlValid = true;
    QString m_yamlErrorMsg;
    QVariantList m_yamlModel;

    YAML::Node yamlContent;
};
