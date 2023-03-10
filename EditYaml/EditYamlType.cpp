#include "EditYamlType.h"

void EditYamlType::setText(const QString &text)
{
    if (text == m_text)
        return;

    m_text = text;
    emit textChanged();

    setIsYamlValid(true);
    if (m_text.startsWith("#")) {
        setIsYamlValid(false);
        setYamlErrorMsg("YAML should not start with #");
        return;
    }
    setYamlErrorMsg("");
    QVariantList list;
    m_yamlModel = list;
    emit yamlModelChanged();

    try {
        yamlContent = YAML::Load(m_text.toStdString());
    } catch (const std::exception &e) {
        setIsYamlValid(false);
        setYamlErrorMsg(e.what());
        return;
    }
    if (!yamlContent.IsMap()) {
        setIsYamlValid(false);
        setYamlErrorMsg("YAML Expected MAP format");
        return;
    }
    bool hasFieldTypes = false;
    for (YAML::const_iterator it = yamlContent.begin(); it != yamlContent.end(); ++it) {
        if (!it->first.IsScalar()) {
            setIsYamlValid(false);
            setYamlErrorMsg("YAML Expected MAP format");
            return;
        }
        std::string key = it->first.as<std::string>();
        if (key == "fields type") {
            hasFieldTypes = true;
        }
    }

    for (YAML::const_iterator it = yamlContent.begin(); it != yamlContent.end(); ++it) {
        if (!it->first.IsScalar()) {
            setIsYamlValid(false);
            setYamlErrorMsg("YAML Expected MAP format");
            return;
        }
        if (!it->second.IsScalar()) {
            continue;
        }
        std::string key = it->first.as<std::string>();
        std::string val = it->second.as<std::string>();
        QVariantMap map;

        map.insert("key", QString::fromStdString(key));
        map.insert("val", QString::fromStdString(val));
        QString inputType = "";
        if (hasFieldTypes) {
            try {
                if (yamlContent["fields type"][key]) {
                    inputType = QString::fromStdString(
                                yamlContent["fields type"][key].as<std::string>());
                }
            } catch (...) {
                // TODO - should we log this somehow?
            }
        }
        if (inputType.isEmpty()) {
            inputType = "textedit";
        }
        map.insert("inputType", inputType);
        list << map;
    }
    m_yamlModel = list;
    emit yamlModelChanged();
}

void EditYamlType::setIsYamlValid(const bool &isYamlValid)
{
    if (isYamlValid == m_isYamlValid)
        return;

    m_isYamlValid = isYamlValid;
    emit isYamlValidChanged();
}

void EditYamlType::setYamlErrorMsg(const QString &yamlErrorMsg)
{
    if (yamlErrorMsg == m_yamlErrorMsg)
        return;

    m_yamlErrorMsg = yamlErrorMsg;
    emit yamlErrorMsgChanged();
}

void EditYamlType::setYamlModel(const QVariantList &yamlModel)
{
    if (yamlModel == m_yamlModel)
        return;

    m_yamlModel = yamlModel;

    YAML::Node nodeData;
    YAML::Node nodeType;

    for (QVariantList::ConstIterator j = yamlModel.begin();
         j != yamlModel.end(); j++)
    {
        nodeData[j->toMap().value("key").toString().toStdString()] = j->toMap().value("val").toString().toStdString();
        nodeType[j->toMap().value("key").toString().toStdString()] = j->toMap().value("inputType").toString().toStdString();
    }
    yamlContent = nodeData;
    yamlContent["fields type"] = nodeType;
    emit yamlModelChanged();
}

QString EditYamlType::getUpdatedText()
{
    for (QVariantList::iterator hehe = m_yamlModel.begin(); hehe != m_yamlModel.end(); hehe++) {
        QVariantMap test = hehe->toMap();
        std::string key = test["key"].toString().toStdString();
        std::string val = test["val"].toString().toStdString();
        yamlContent[key] = val;
    }
    std::stringstream ss;
    ss << yamlContent;
    return QString::fromStdString(ss.str());
}

void EditYamlType::sendChangeType(QString key, QString typeVal)
{
    yamlContent["fields type"][key.toStdString()] = typeVal.toStdString();
}

void EditYamlType::sendChangeVal(QString key, QString val)
{
    for (QVariantList::iterator hehe = m_yamlModel.begin(); hehe != m_yamlModel.end(); hehe++) {
        QVariantMap test = hehe->toMap();
        if (test["key"].toString() == key) {
            test["val"].setValue(QVariant(val));
            *hehe = test;
        }
    }
}
