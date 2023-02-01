#pragma once

#include "yaml-cpp/yaml.h"
#include <QObject>
#include <qqmlregistration.h>

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

signals:
    // hygen signals

private:
    // hygen private
    std::string exampleText = R"(
username: shalomOlam
  This is line 2
password: wqeroiuy123
)";
};
