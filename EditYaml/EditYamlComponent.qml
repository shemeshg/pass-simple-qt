import QtQuick
import EditYaml
import QtQuick.Controls
import QtQuick.Layouts
import InputType


ColumnLayout {
    property alias text: editYamlType.text
    property alias  editYamlType: editYamlType



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

    Repeater {
        visible: editYamlType.isYamlValid
        model: editYamlType.yamlModel
        ColumnLayout {
            Row{
                Text { text:  modelData.key + ": "}
            }
            Row{
                InputTypeComponent {
                    width: scrollViewId.width - 20
                    inputText: modelData.val
                    inputType: modelData.inputType
                     onTextChangedSignal:  function(s){
                       editYamlType.sendChange(modelData.key,s);
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

