import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import DropdownWithList

ColumnLayout {

    FileDialog {
        id: fileDialogUpload
        title: "Choose file to upload"
        fileMode: FileDialog.OpenFile
        onAccepted: {
            getMainqmltype().encryptUpload( fullPathFolder, fileDialogUpload.selectedFile);
        }
        onRejected: {
        }
    }



    id: addComponentId
    RowLayout{
        Label {
            text: "<h1>Add</h1>"
        }
    }
    RowLayout{
        Label {
            text: "Destination folder: " + fullPathFolder
        }
    }
    RowLayout{
        Label {
            text: "<h2>Create empty encrypted text file</h1>"
        }
    }
    RowLayout {
        Label {
            text: "File name"
        }
        TextField {
            id: createEmptyFileNameId
            text: ""
            placeholderText: "FileName.txt"
            Layout.fillWidth: true
            onTextChanged: {
                var makeEnabled = Boolean(nearestGpg) && Boolean( createEmptyFileNameId.text);
                if (getMainqmltype().fileExists(fullPathFolder, createEmptyFileNameId.text)){
                    makeEnabled = false;
                }
                addBtnId.enabled = makeEnabled
            }
        }
        Button {
            id: addBtnId
            text: "add";
            enabled: Boolean(nearestGpg) && Boolean( createEmptyFileNameId.text)
            onClicked: {
                getMainqmltype().createEmptyEncryptedFile(fullPathFolder, createEmptyFileNameId.text)
                createEmptyFileNameId.text = ""
            }
        }
    }
    RowLayout{
        Label {
            text: "<h2>Upload existing file</h2>"
        }
    }
    RowLayout {
        Button {
            text: "upload"
            enabled: Boolean(nearestGpg)
            onClicked: fileDialogUpload.open()
        }
    }

}
