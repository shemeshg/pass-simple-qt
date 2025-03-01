#include "EditYamlType.h"
#include <QMap>

void EditYamlType::setText(const QString &text)
{
    if (text == m_text)
        return;

    m_text = text;
    emit textChanged();

    setIsYamlValid(true);
    if (m_text.startsWith("#") || m_text.startsWith("-") || m_text.isEmpty()) {
        setIsYamlValid(false);
        setYamlErrorMsg("YAML should not start with # or - or be empty");
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

        QString qval = QString::fromStdString(val);
        if (qval.endsWith("\n")) {
            qval.chop(1);
        }

        map.insert("key", QString::fromStdString(key));
        map.insert("val", qval);
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

void EditYamlType::clearYamlContent()
{
    std::vector<std::string> keysToRemove = {"fields type"};
    for (YAML::const_iterator it = yamlContent.begin(); it != yamlContent.end(); ++it) {

        if(it->first.IsScalar() && it->second.IsScalar()){
            keysToRemove.push_back(it->first.as<std::string>());
        }
    }

    for (std::string &key: keysToRemove){
        yamlContent.remove(key);
    }
}

void EditYamlType::setYamlModel(const QVariantList &yamlModel)
{
    if (yamlModel == m_yamlModel)
        return;

    m_yamlModel = yamlModel;

    clearYamlContent();


    YAML::Node nodeType;

    for (QVariantList::ConstIterator j = yamlModel.begin();
         j != yamlModel.end(); j++)
    {
        yamlContent[j->toMap().value("key").toString().toStdString()] = j->toMap().value("val").toString().toStdString();
        nodeType[j->toMap().value("key").toString().toStdString()] = j->toMap().value("inputType").toString().toStdString();
    }

    yamlContent["fields type"] = nodeType;
    emit yamlModelChanged();
}

QString EditYamlType::getUpdatedText()
{
    QMap<QString, QString> replaceMap;
    for (QVariantList::iterator hehe = m_yamlModel.begin(); hehe != m_yamlModel.end(); hehe++) {
        QVariantMap test = hehe->toMap();
        std::string key = test["key"].toString().toStdString();
        std::string val = test["val"].toString().toStdString();
        yamlContent[key] = val;
        if(test["val"].toString().contains("\n") && !test["val"].toString().startsWith(" ")){
            YAML::Emitter outFrom, outTo;
            outFrom << YAML::BeginMap;
            outFrom << YAML::Key << test["key"].toString().toStdString();
            outFrom << YAML::Value << test["val"].toString().toStdString();
            outFrom << YAML::EndMap;
            outTo << YAML::BeginMap;
            outTo << YAML::Key << test["key"].toString().toStdString();
            outTo << YAML::Value << YAML::Literal << test["val"].toString().toStdString();
            outTo << YAML::EndMap;

            QString fixedMultiLineIndicator = outTo.c_str();
            qsizetype newline = fixedMultiLineIndicator.indexOf('\n');
            if (fixedMultiLineIndicator[newline - 1] == '|')
            {
                fixedMultiLineIndicator.replace(newline - 1, 1, "|+");
            }

            replaceMap.insert(outFrom.c_str(), fixedMultiLineIndicator);
        }
    }
    std::stringstream ss;
    ss << yamlContent;
    QString qs=QString::fromStdString(ss.str());
    for (auto [key, value] : replaceMap.asKeyValueRange()) {
        qs.replace(key,value);
    }
    return qs;
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
