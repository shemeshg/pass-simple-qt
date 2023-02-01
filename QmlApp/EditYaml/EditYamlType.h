#pragma once

#include "yaml-cpp/yaml.h"
#include <QObject>
#include <qqmlregistration.h>
#include <QVariantMap>


class EditYamlType : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
    Q_PROPERTY(bool isYamlValid READ isYamlValid WRITE setIsYamlValid NOTIFY isYamlValidChanged)
    Q_PROPERTY(QString yamlErrorMsg READ yamlErrorMsg WRITE setYamlErrorMsg NOTIFY yamlErrorMsgChanged)
    Q_PROPERTY(QVariantList yamlModel READ yamlModel WRITE setYamlModel NOTIFY yamlModelChanged)
    // hygen Q_PROPERTY
    QML_ELEMENT

public:
    explicit EditYamlType(QObject *parent = nullptr) : QObject(parent){};

    QString text()
    {
        return m_text;
    };

    void setText(const QString &text)
    {
        if (text == m_text)
            return;

        m_text = text;
        emit textChanged();

        setIsYamlValid(true);
        setYamlErrorMsg("");
        QVariantList list;
        m_yamlModel = list;
        emit yamlModelChanged();

        try {
            yamlContent = YAML::Load(m_text.toStdString());
        }
        catch (const std::exception &e) {
            setIsYamlValid(false);
            setYamlErrorMsg(e.what());
            return;
        }
        if(!yamlContent.IsMap()){
            setIsYamlValid(false);
            setYamlErrorMsg("YAML Expected MAP format");
            return;
        }        
        for(YAML::const_iterator it=yamlContent.begin();it != yamlContent.end();++it) {
            if (!it->first.IsScalar()){
                setIsYamlValid(false);
                setYamlErrorMsg("YAML Expected MAP format");
                return;
            ;}
            if (!it->second.IsScalar()){continue;}
            std::string key = it->first.as<std::string>();
            std::string val = it->second.as<std::string>();
            QVariantMap map;
            map.insert("key",QString::fromStdString( key));
            map.insert("val", QString::fromStdString( val));
            list<<map;
        }
        m_yamlModel = list;
        emit yamlModelChanged();
    }
    bool isYamlValid()
    {
        return m_isYamlValid;
    };

    void setIsYamlValid(const bool &isYamlValid)
    {
        if (isYamlValid == m_isYamlValid)
            return;

        m_isYamlValid = isYamlValid;
        emit isYamlValidChanged();
    }
    QString yamlErrorMsg()
    {
        return m_yamlErrorMsg;
    };

    void setYamlErrorMsg(const QString &yamlErrorMsg)
    {
        if (yamlErrorMsg == m_yamlErrorMsg)
            return;

        m_yamlErrorMsg = yamlErrorMsg;
        emit yamlErrorMsgChanged();

    }
    QVariantList yamlModel()
    {
        return m_yamlModel;
    };

    void setYamlModel(const QVariantList &yamlModel)
    {
        if (yamlModel == m_yamlModel)
            return;

        m_yamlModel = yamlModel;
        emit yamlModelChanged();
    }
    // hygen public


signals:
    void textChanged();
    void isYamlValidChanged();
    void yamlErrorMsgChanged();
    void yamlModelChanged();
    // hygen signals

private:
    QString m_text;
    bool m_isYamlValid = true;
    QString m_yamlErrorMsg;
    QVariantList m_yamlModel;
    // hygen private


    YAML::Node yamlContent;
};
