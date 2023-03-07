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

        }
        Button {
            visible: isEditFieldsType
            onClicked: {
                addDialog.open()
            }
            icon.name: "Add"
            ToolTip.text: "Add"
            icon.source: "icons/outline_control_point_black_24dp.png"
            ToolTip.visible: hovered
        }
    }

    function arrayMove(oldIndex: number, newIndex) {
        let arr = editYamlType.yamlModel;
          while (oldIndex < 0) {
              oldIndex += arr.length;
          }
          while (newIndex < 0) {
              newIndex += arr.length;
          }
          if (newIndex >= arr.length) {
              newIndex = 0 ;
          }
          let newArry = [...arr]
          newArry.splice(newIndex, 0, newArry.splice(oldIndex, 1)[0]);
          editYamlType.yamlModel = newArry;
      }

    property int dialogRowIdx: -1
    Dialog {
        id: renameDialog
        title: "Set field name"
        width: parent.width * 0.75

        standardButtons: Dialog.Ok | Dialog.Cancel
        TextField {
            id: fieldName
            focus: true
            text: dialogRowIdx > -1 ? editYamlType.yamlModel[dialogRowIdx].key : ""
            width: parent.width

        }
        onAccepted: {
            let newArry = [...editYamlType.yamlModel]
            newArry[dialogRowIdx].key = fieldName.text
            editYamlType.yamlModel = newArry;
        }
        onClosed: {
            dialogRowIdx = -1;
        }
    }


    Dialog {
        id: addDialog
        title: "Set new field name"
        width: parent.width * 0.75

        standardButtons: Dialog.Ok | Dialog.Cancel
        TextField {
            id: newFieldName
            focus: true
            text: ""
            width: parent.width

        }
        onAccepted: {
            if (!newFieldName.text){return;}
            let newArry = [...editYamlType.yamlModel]
            newArry.push({inputType: "textedit", key: newFieldName.text, val: ""})
            editYamlType.yamlModel = newArry;
        }
        onClosed: {
            dialogRowIdx = -1;
        }
    }

    ListView {
        id: yamlModelListViewId
        model: editYamlType.yamlModel
        visible: editYamlType.isYamlValid
        clip: true

        ScrollBar.vertical: ScrollBar {}
        Layout.fillWidth: true        
        Layout.fillHeight: true

        flickableDirection: Flickable.VerticalFlick
        boundsBehavior: Flickable.StopAtBounds

        delegate: ColumnLayout {
                width: yamlModelListViewId.width
                Row{
                    Layout.fillWidth: true

                    Text {
                        text:  modelData.key + ": "                       
                        padding: 8

                    }
                    ComboBox {
                        id: selectedInputType
                        visible: isEditFieldsType
                        height: moveUpId.height
                        model: ["textedit", "text","url","password","totp","datetime"]
                        Component.onCompleted: {
                            currentIndex = find(modelData.inputType);
                        }
                        //width: 200
                        onActivated:    {
                            editYamlType.sendChangeType(modelData.key,currentText);
                            inputTypeComponentId.inputType = currentText;
                        }

                    }
                    Button {
                        id: moveUpId
                        visible: isEditFieldsType
                        onClicked: ()=>{
                                       arrayMove(index, index - 1)
                                   }
                        icon.name: "Up"
                        ToolTip.text: "Up"
                        icon.source: "icons/outline_move_up_black_24dp.png"
                        ToolTip.visible: hovered

                    }
                    Button {
                        visible: isEditFieldsType
                        onClicked: ()=>{
                                       arrayMove(index, index + 1)
                                   }
                        icon.name: "Down"
                        ToolTip.text: "Down"
                        icon.source: "icons/outline_move_down_black_24dp.png"
                        ToolTip.visible: hovered
                    }
                    Button {
                        visible: isEditFieldsType
                        onClicked: ()=>{
                                dialogRowIdx = index;
                                renameDialog.open();
                                   }
                        icon.name: "Rename"
                        ToolTip.text: "Rename"
                        icon.source: "icons/outline_edit_black_24dp.png"
                        ToolTip.visible: hovered
                    }
                    Button {
                        visible: isEditFieldsType
                        onClicked: {
                            dialogRowIdx = index;
                            addDialog.open()
                        }
                        icon.name: "Delete"
                        ToolTip.text: "Delete"
                        icon.source: "icons/outline_remove_circle_outline_black_24dp.png"
                        ToolTip.visible: hovered
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

