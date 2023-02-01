import QtQuick
import EditYaml
import QtQuick.Controls
import QtQuick.Layouts



ColumnLayout {
    property alias text: editYamlType.text

    EditYamlType {
        id: editYamlType
    }
    Button {
        text:"TEST"
        onClicked: {
                    console.log( editYamlType.getUpdatedText() );}
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
                TextEditComponent {
                    width: scrollViewId.width - 20
                    textEdit.text: modelData.val
                    onTextChanged: {
                       editYamlType.sendChange(modelData.key,textEdit.text);
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

