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





        Text {
            id: decryptedTextId
            text:"decrypted : " + decryptedText
        }

        Text {
            id: filepansizeId
            text:"FilePanSize : " + filePanSize
        }
        Text {
            id: nameId
            text:"File : " + filePath
        }

        Button {
            text: "Hide/Show treeview"
            onClicked: { mainLayout.toggleFilepan()}
        }
    }
}
