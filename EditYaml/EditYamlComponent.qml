import QtQuick
import EditYaml
import QtQuick.Controls
import QtQuick.Layouts
import InputType


ColumnLayout {
    property alias text: editYamlType.text
    property alias  editYamlType: editYamlType
    property bool isEditFieldsType: false
    height: parent.height
    width:  parent.width

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

    Rectangle {
        visible: editYamlType.isYamlValid
        Layout.fillWidth: true
        Layout.preferredHeight: 1
        color: "white"
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
            bottomPadding: 20;
        }
    }

    ListView {
        id: yamlModelListViewId
        model: editYamlType.yamlModel
        visible: editYamlType.isYamlValid

        ScrollBar.vertical: ScrollBar {}
        Layout.fillWidth: true
        width: parent.width
        //Layout.fillHeight: true
        height: 400

        flickableDirection: Flickable.VerticalFlick
        boundsBehavior: Flickable.StopAtBounds
        delegate:         ColumnLayout {
                width: yamlModelListViewId.width
                Row{
                    Layout.fillWidth: true
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
                    Layout.fillWidth: true
                    InputTypeComponent {
                        id: inputTypeComponentId
                        width: parent.width
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

