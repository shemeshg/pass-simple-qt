import QtQuick
import EditYaml
import QtQuick.Controls
import QtQuick.Layouts


ColumnLayout {
    EditYamlType {
        id: editYamlType
    }


    Repeater {
        model: editYamlType.getYamlFmodel()
        ColumnLayout {
            Row{
                Text { text:  modelData.key + ": "}
            }
            Row{
                TextEditComponent {
                    width: scrollViewId.width - 20
                    textEdit.text: modelData.val
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

