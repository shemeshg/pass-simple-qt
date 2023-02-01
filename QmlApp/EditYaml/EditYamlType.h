#pragma once

#include "yaml-cpp/yaml.h"
#include <QObject>
#include <qqmlregistration.h>
#include <QVariantMap>


class EditYamlType : public QObject {
    Q_OBJECT
    // hygen Q_PROPERTY
    QML_ELEMENT

public:
    explicit EditYamlType(QObject *parent = nullptr) : QObject(parent){};

    // hygen public

    Q_INVOKABLE QString getYamlFields() {
        std::string ret = "";
        try {
            YAML::Node config = YAML::Load(exampleText);
            if (config["username"]) {
                ret = config["username"].as<std::string>();
            }
            return QString::fromStdString(ret);
        } catch (const YAML::ParserException &ex) {
            return ex.what();
        }
    }

    Q_INVOKABLE QVariantList getYamlFmodel() {
        QVariantList list;
        try {
            YAML::Node content = YAML::Load(exampleText);
            for(YAML::const_iterator it=content.begin();it != content.end();++it) {
               std::string key = it->first.as<std::string>();       // <- key
               std::string val = it->second.as<std::string>();       // <- key
               QVariantMap map;
               map.insert("key",QString::fromStdString( key));
               map.insert("val", QString::fromStdString( val));
               list<<map;
            }

        } catch (const std::exception &ex) {
            throw;
        }

        return list;
    }

signals:
    // hygen signals

private:
    // hygen private
    std::string exampleText = R"(
username: shalomOlam
  This is line 2
password:
  wqeroiuy123

)";
};
