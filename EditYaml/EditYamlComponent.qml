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
                        model: ["textedit", "text","url","password","totp","datetime"]
                        Component.onCompleted: {
                            currentIndex = find(modelData.inputType);
                        }
                        width: 200
                        onActivated:    {
                            editYamlType.sendChangeType(modelData.key,currentText);
                            inputTypeComponentId.inputType = currentText;
                        }

                    }
                    Button {
                        text: "Up "
                        onClicked: ()=>{
                                       arrayMove(index, index - 1)
                                   }

                    }
                    Button {
                        text: "Down"
                        onClicked: ()=>{
                                       arrayMove(index, index + 1)
                                   }
                    }
                    Button {
                        text: "Ren"
                        onClicked: ()=>{
                                dialogRowIdx = index;
                                renameDialog.open();

                                   }
                    }
                    Button {
                        text: "Del"
                        onClicked: {
                            let newArry = [...editYamlType.yamlModel]
                            newArry.splice(index,1)
                            editYamlType.yamlModel = newArry;
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

