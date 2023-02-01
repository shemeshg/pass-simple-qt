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

    Q_INVOKABLE QVariantList getYamlFmodel() {
        QVariantList list;
        try {
            YAML::Node content = YAML::Load(exampleText);
            if(!content.IsMap()){return list;}
            for(YAML::const_iterator it=content.begin();it != content.end();++it) {
                if (!it->first.IsScalar()){continue;}
                if (!it->second.IsScalar()){continue;}
                std::string key = it->first.as<std::string>();
                std::string val = it->second.as<std::string>();
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
