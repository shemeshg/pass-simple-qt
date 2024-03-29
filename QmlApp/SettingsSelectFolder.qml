import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QmlCore

import Qt.labs.platform

RowLayout {
    FolderDialog {
        property var callback: () => {}
        id: selectTmpFolderPathDialogId
        title: "Select folder"
        onAccepted: {
            callback()
        }
        onRejected: {

        }
    }

    property alias text: coreTextField.text
    property alias hooverText: coreButton.hooverText
    signal setPath(string s)
    signal textChanged1

    CoreTextField {
        id: coreTextField
        Layout.fillWidth: true
        onTextChanged: {
            textChanged1()
        }
    }
    CoreButton {
        id: coreButton
        text: String.fromCodePoint(0x1F4C1)
        onClicked: {
            selectTmpFolderPathDialogId.callback = () => {
                let path = selectTmpFolderPathDialogId.currentFolder.toString()
                path = path.replace(/^(file:\/{3})/, "")
                // unescape html codes like '%23' for '#'
                path = decodeURIComponent(path)

                setPath("/" + path)
            }

            selectTmpFolderPathDialogId.open()
        }
    }
}
