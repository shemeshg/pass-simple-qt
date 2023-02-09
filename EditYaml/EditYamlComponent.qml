import QtQuick
import EditYaml
import QtQuick.Controls
import QtQuick.Layouts
import InputType


ColumnLayout {
    property alias text: editYamlType.text
    property alias  editYamlType: editYamlType
    property bool isEditFieldsType: false


    Component {
        id: menuItem
        MenuItem {

        }
    }


    EditYamlType {
        id: editYamlType
        onYamlModelChanged: {
            clearSystemTrayIconEntries()
            for(var idx in yamlModel){
                addSystemTrayIconEntries(yamlModel[idx].key,
                                         yamlModel[idx].val,
                                         yamlModel[idx].inputType)
            }
        }

    }


    Row{
        Text { text:  Error + ": " + editYamlType.yamlErrorMsg }
        visible: !editYamlType.isYamlValid
    }

    ColumnLayout{
        visible: editYamlType.isYamlValid
    Repeater {

        model: editYamlType.yamlModel
        ColumnLayout {
            Row{
                Text {
                    text:  modelData.key + ": "
                    bottomPadding: 8
                    topPadding: 8

                }
                ComboBox {
                    id: selectedInputType
                    visible: isEditFieldsType
                    model: ["textedit", "text","url","password","totp"]
                    Component.onCompleted: {
                        currentIndex = find(modelData.inputType);
                    }
                    width: 200
                    onActivated:    {
                        editYamlType.sendChangeType(modelData.key,currentText);
                        inputTypeComponentId.inputType = currentText;
                    }

                }
            }
            Row{
                InputTypeComponent {
                    id: inputTypeComponentId
                    width: scrollViewId.width - 20
                    inputText: modelData.val
                    inputType: modelData.inputType
                    onTextChangedSignal:  function(s){
                        editYamlType.sendChangeVal(modelData.key,s);
                    }
                }
            }
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: "black"
            }
        }


    }
    }

    Row{
        visible: editYamlType.isYamlValid
        Rectangle {
            color: "white"
            width: scrollViewId.width - 20
            height: 2
        }
    }    
    RowLayout {
        visible: editYamlType.isYamlValid
        Switch {
            id: idEditFieldsType
            text: qsTr("Edit fields type")
            checked: isEditFieldsType;
            onCheckedChanged: {
                isEditFieldsType = !isEditFieldsType;
            }
        }
    }
}

