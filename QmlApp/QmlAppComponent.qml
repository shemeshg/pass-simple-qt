import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls

Item {
    property int filePanSize: 0
    property string filePath: ""
    property string decryptedText: ""

    onFilePathChanged: { decryptedTextId.text = mainLayout.getDecrypted() }

    ColumnLayout {
        anchors.fill: parent

        Text {
            id: nameId
            text:"File : " + filePath
        }
        Text {
            id: decryptedTextId
            text:""
        }


        Button {
            text: "Hide/Show treeview"
            onClicked: { mainLayout.toggleFilepan()}
        }
    }
}
