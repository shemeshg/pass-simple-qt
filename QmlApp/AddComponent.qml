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

    FileDialog {
        id: fileDialogDownload
        title: "Choose folder to download"
        onAccepted: {
            getMainqmltype().decryptDownload(fileDialogDownload.selectedFile)
        }
        onRejected: {
        }
        fileMode: FileDialog.SaveFile

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
        }
        Button {
            text: "add";
            enabled: Boolean(nearestGpg) && Boolean( createEmptyFileNameId.text)
            onClicked: getMainqmltype().createEmptyEncryptedFile(fullPathFolder, createEmptyFileNameId.text)
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
    RowLayout{
        Label {
            text: "<h2>Download selected file</h2>"
        }
    }
    Text {
        text:"File : " + filePath
    }
    RowLayout {
        Button {
            text: "download"
            enabled: isGpgFile
            onClicked: fileDialogDownload.open()
        }
    }
}
